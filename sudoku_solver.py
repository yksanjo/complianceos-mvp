#!/usr/bin/env python3
"""
Sudoku Solver
==============
An elegant implementation using constraint propagation + backtracking with MRV heuristic.

Algorithm:
1. Constraint Propagation: Eliminate impossible values using naked/hidden singles
2. Backtracking: Recursive search when constraints are insufficient
3. MRV Heuristic: Choose variable with Minimum Remaining Values first

Complexity: O(9^m) where m = number of empty cells (pruned dramatically by constraints)
"""

from typing import Optional, Set, List, Tuple
from copy import deepcopy
from dataclasses import dataclass
import time


@dataclass
class Cell:
    """Represents a single Sudoku cell with its domain of possible values."""
    value: Optional[int] = None
    domain: Set[int] = None
    
    def __post_init__(self):
        if self.domain is None:
            self.domain = set(range(1, 10)) if self.value is None else {self.value}
    
    def is_solved(self) -> bool:
        return self.value is not None
    
    def copy(self) -> 'Cell':
        return Cell(self.value, self.domain.copy())


class SudokuBoard:
    """9x9 Sudoku board with constraint propagation capabilities."""
    
    def __init__(self, grid: Optional[List[List[int]]] = None):
        self.cells: List[List[Cell]] = []
        self._init_cells(grid)
    
    def _init_cells(self, grid: Optional[List[List[int]]]):
        """Initialize cells from a 9x9 grid (0 or None represents empty)."""
        for row in range(9):
            cell_row = []
            for col in range(9):
                val = grid[row][col] if grid else 0
                value = val if val != 0 else None
                cell_row.append(Cell(value))
            self.cells.append(cell_row)
        self._initialize_domains()
    
    def _initialize_domains(self):
        """Set initial domains based on given values."""
        for row in range(9):
            for col in range(9):
                if self.cells[row][col].is_solved():
                    self._propagate_constraint(row, col)
    
    def get(self, row: int, col: int) -> Optional[int]:
        return self.cells[row][col].value
    
    def set(self, row: int, col: int, value: int):
        """Set a value and propagate constraints."""
        cell = self.cells[row][col]
        cell.value = value
        cell.domain = {value}
        self._propagate_constraint(row, col)
    
    def _propagate_constraint(self, row: int, col: int):
        """Remove the placed value from peers' domains."""
        value = self.cells[row][col].value
        
        # Row peers
        for c in range(9):
            if c != col:
                self.cells[row][c].domain.discard(value)
        
        # Column peers
        for r in range(9):
            if r != row:
                self.cells[r][col].domain.discard(value)
        
        # Box peers
        box_row, box_col = 3 * (row // 3), 3 * (col // 3)
        for r in range(box_row, box_row + 3):
            for c in range(box_col, box_col + 3):
                if r != row or c != col:
                    self.cells[r][c].domain.discard(value)
    
    def find_naked_singles(self) -> List[Tuple[int, int, int]]:
        """Find cells with only one possible value in their domain."""
        singles = []
        for row in range(9):
            for col in range(9):
                cell = self.cells[row][col]
                if not cell.is_solved() and len(cell.domain) == 1:
                    singles.append((row, col, next(iter(cell.domain))))
        return singles
    
    def find_hidden_singles(self) -> List[Tuple[int, int, int]]:
        """Find values that can only go in one cell within a unit (row/col/box)."""
        singles = []
        
        # Check rows
        for row in range(9):
            value_positions = {v: [] for v in range(1, 10)}
            for col in range(9):
                cell = self.cells[row][col]
                if not cell.is_solved():
                    for v in cell.domain:
                        value_positions[v].append(col)
            for val, positions in value_positions.items():
                if len(positions) == 1:
                    singles.append((row, positions[0], val))
        
        # Check columns
        for col in range(9):
            value_positions = {v: [] for v in range(1, 10)}
            for row in range(9):
                cell = self.cells[row][col]
                if not cell.is_solved():
                    for v in cell.domain:
                        value_positions[v].append(row)
            for val, positions in value_positions.items():
                if len(positions) == 1:
                    singles.append((positions[0], col, val))
        
        # Check boxes
        for box_row in range(3):
            for box_col in range(3):
                value_positions = {v: [] for v in range(1, 10)}
                for r in range(3):
                    for c in range(3):
                        row, col = box_row * 3 + r, box_col * 3 + c
                        cell = self.cells[row][col]
                        if not cell.is_solved():
                            for v in cell.domain:
                                value_positions[v].append((row, col))
                for val, positions in value_positions.items():
                    if len(positions) == 1:
                        singles.append((positions[0][0], positions[0][1], val))
        
        # Remove duplicates
        seen = set()
        unique = []
        for s in singles:
            key = (s[0], s[1])
            if key not in seen:
                seen.add(key)
                unique.append(s)
        return unique
    
    def constraint_propagation(self) -> bool:
        """
        Apply constraint propagation iteratively.
        Returns False if a contradiction is found (empty domain).
        """
        changed = True
        while changed:
            changed = False
            
            # Naked singles
            for row, col, val in self.find_naked_singles():
                self.set(row, col, val)
                changed = True
            
            # Hidden singles
            for row, col, val in self.find_hidden_singles():
                if not self.cells[row][col].is_solved():
                    self.set(row, col, val)
                    changed = True
            
            # Check for contradictions
            for row in range(9):
                for col in range(9):
                    cell = self.cells[row][col]
                    if not cell.is_solved() and len(cell.domain) == 0:
                        return False
        return True
    
    def select_unassigned_variable(self) -> Optional[Tuple[int, int]]:
        """
        MRV (Minimum Remaining Values) heuristic.
        Select the unsolved cell with the smallest domain.
        """
        min_domain_size = float('inf')
        best_cell = None
        
        for row in range(9):
            for col in range(9):
                cell = self.cells[row][col]
                if not cell.is_solved():
                    domain_size = len(cell.domain)
                    if domain_size < min_domain_size:
                        min_domain_size = domain_size
                        best_cell = (row, col)
        
        return best_cell
    
    def is_complete(self) -> bool:
        """Check if all cells are solved."""
        return all(self.cells[r][c].is_solved() for r in range(9) for c in range(9))
    
    def copy(self) -> 'SudokuBoard':
        """Deep copy of the board."""
        new_board = SudokuBoard()
        new_board.cells = [[cell.copy() for cell in row] for row in self.cells]
        return new_board
    
    def __str__(self) -> str:
        """Pretty print the board."""
        lines = []
        for row in range(9):
            if row % 3 == 0 and row != 0:
                lines.append("------+-------+------")
            row_str = ""
            for col in range(9):
                if col % 3 == 0 and col != 0:
                    row_str += "| "
                val = self.cells[row][col].value
                row_str += f"{val if val else '.'} "
            lines.append(row_str)
        return "\n".join(lines)
    
    def compact_str(self) -> str:
        """Single line representation."""
        return "".join(
            str(self.cells[r][c].value) if self.cells[r][c].value else '.'
            for r in range(9) for c in range(9)
        )


class SudokuSolver:
    """Backtracking solver with constraint propagation."""
    
    def __init__(self, verbose: bool = False):
        self.verbose = verbose
        self.nodes_explored = 0
        self.backtracks = 0
    
    def solve(self, board: SudokuBoard) -> Optional[SudokuBoard]:
        """
        Solve the Sudoku puzzle.
        Returns solved board or None if unsolvable.
        """
        self.nodes_explored = 0
        self.backtracks = 0
        
        # First, apply constraint propagation
        if not board.constraint_propagation():
            return None
        
        result = self._backtrack(board)
        return result
    
    def _backtrack(self, board: SudokuBoard) -> Optional[SudokuBoard]:
        """Recursive backtracking search."""
        self.nodes_explored += 1
        
        # Check if complete
        if board.is_complete():
            return board
        
        # Select variable using MRV heuristic
        var = board.select_unassigned_variable()
        if var is None:
            return None
        
        row, col = var
        domain = sorted(board.cells[row][col].domain)  # Sort for determinism
        
        if self.verbose:
            print(f"  Trying cell ({row},{col}) with domain {domain}")
        
        for value in domain:
            # Create copy and try assignment
            new_board = board.copy()
            new_board.set(row, col, value)
            
            # Apply constraint propagation
            if not new_board.constraint_propagation():
                self.backtracks += 1
                continue
            
            # Recursive call
            result = self._backtrack(new_board)
            if result is not None:
                return result
            
            self.backtracks += 1
        
        return None


def parse_puzzle(puzzle_str: str) -> List[List[int]]:
    """Parse puzzle from string (81 chars, '.' or '0' for empty)."""
    puzzle_str = puzzle_str.replace('.', '0').replace(' ', '')
    if len(puzzle_str) != 81:
        raise ValueError(f"Puzzle must be 81 characters, got {len(puzzle_str)}")
    
    grid = []
    for i in range(9):
        row = [int(puzzle_str[i * 9 + j]) for j in range(9)]
        grid.append(row)
    return grid


def run_benchmark():
    """Run solver on puzzles of varying difficulty."""
    puzzles = {
        "Easy": (
            "530070000"
            "600195000"
            "098000060"
            "800060003"
            "400803001"
            "700020006"
            "060000280"
            "000419000"
            "000080079"
        ),
        "Medium": (
            "000000907"
            "000420180"
            "000705026"
            "100904000"
            "050000040"
            "000507009"
            "920108000"
            "034059000"
            "507000000"
        ),
        "Hard": (
            "000006000"
            "059000008"
            "200008000"
            "045000000"
            "003000000"
            "006003054"
            "000325000"
            "000000000"
            "000000000"
        ),
        "Expert": (
            "000000010"
            "400000000"
            "020000000"
            "000050407"
            "008000300"
            "001090000"
            "300400200"
            "050100000"
            "000806000"
        ),
        "World's Hardest": (
            "850000000"
            "000000076"
            "000003040"
            "007020500"
            "060000010"
            "002010300"
            "090800000"
            "410000000"
            "000000098"
        )
    }
    
    print("=" * 60)
    print("SUDOKU SOLVER BENCHMARK")
    print("=" * 60)
    print("Algorithm: Constraint Propagation + Backtracking + MRV\n")
    
    for name, puzzle in puzzles.items():
        print(f"\n{'─' * 50}")
        print(f"Puzzle: {name}")
        print(f"{'─' * 50}")
        
        grid = parse_puzzle(puzzle)
        board = SudokuBoard(grid)
        
        print("Initial board:")
        print(board)
        print()
        
        solver = SudokuSolver(verbose=False)
        start = time.perf_counter()
        solution = solver.solve(board)
        elapsed = time.perf_counter() - start
        
        if solution:
            print("Solution:")
            print(solution)
            print(f"\n⏱ Time: {elapsed*1000:.2f}ms")
            print(f"🔍 Nodes explored: {solver.nodes_explored}")
            print(f"↩️ Backtracks: {solver.backtracks}")
            
            # Validate solution
            is_valid, errors = validate_solution(solution)
            if is_valid:
                print("✅ Solution validated")
            else:
                print(f"❌ Invalid solution: {errors}")
        else:
            print("❌ No solution found!")


def demo_step_by_step():
    """Show how constraint propagation works step by step."""
    puzzle = (
        "530070000"
        "600195000"
        "098000060"
        "800060003"
        "400803001"
        "700020006"
        "060000280"
        "000419000"
        "000080079"
    )
    
    print("=" * 60)
    print("STEP-BY-STEP CONSTRAINT PROPAGATION DEMO")
    print("=" * 60)
    
    grid = parse_puzzle(puzzle)
    board = SudokuBoard(grid)
    
    print("\nInitial board:")
    print(board)
    
    print("\nInitial domains for empty cells in row 0:")
    for col in range(9):
        cell = board.cells[0][col]
        if not cell.is_solved():
            print(f"  Cell (0,{col}): {sorted(cell.domain)}")
    
    print("\nApplying constraint propagation...")
    
    iteration = 0
    while True:
        naked = board.find_naked_singles()
        hidden = board.find_hidden_singles()
        
        if not naked and not hidden:
            break
        
        iteration += 1
        print(f"\n--- Iteration {iteration} ---")
        
        for row, col, val in naked:
            print(f"  Naked single: ({row},{col}) = {val}")
            board.set(row, col, val)
        
        for row, col, val in hidden:
            if not board.cells[row][col].is_solved():
                print(f"  Hidden single: ({row},{col}) = {val}")
                board.set(row, col, val)
    
    print(f"\nAfter constraint propagation ({iteration} iterations):")
    print(board)
    
    # Count remaining unsolved cells
    unsolved = sum(1 for r in range(9) for c in range(9) if not board.cells[r][c].is_solved())
    print(f"\nUnsolved cells remaining: {unsolved}")
    
    if unsolved > 0:
        print("\nBacktracking needed for remaining cells...")
        solver = SudokuSolver()
        final = solver._backtrack(board)
        if final:
            print("\nFinal solution:")
            print(final)


def interactive_solver():
    """Interactive mode for solving custom puzzles."""
    print("=" * 60)
    print("INTERACTIVE SUDOKU SOLVER")
    print("=" * 60)
    print("\nEnter puzzle as 81 characters (0 or . for empty cells)")
    print("Or press Enter for default puzzle")
    
    user_input = input("\nPuzzle: ").strip()
    
    if not user_input:
        user_input = (
            "530070000"
            "600195000"
            "098000800"
            "800060003"
            "400803001"
            "700020006"
            "060000280"
            "000419000"
            "000080079"
        )
        print(f"Using default puzzle: {user_input}")
    
    try:
        grid = parse_puzzle(user_input)
        board = SudokuBoard(grid)
        
        print("\nInput puzzle:")
        print(board)
        
        solver = SudokuSolver()
        start = time.perf_counter()
        solution = solver.solve(board)
        elapsed = time.perf_counter() - start
        
        if solution:
            print("\n✅ Solution found!")
            print(solution)
            print(f"\n⏱ Time: {elapsed*1000:.2f}ms")
            print(f"🔍 Nodes explored: {solver.nodes_explored}")
            print(f"↩️ Backtracks: {solver.backtracks}")
        else:
            print("\n❌ Invalid puzzle - no solution exists!")
            
    except ValueError as e:
        print(f"Error: {e}")


def validate_solution(board: SudokuBoard) -> Tuple[bool, List[str]]:
    """
    Validate that a solution is correct.
    Returns (is_valid, list_of_errors).
    """
    errors = []
    
    # Check rows
    for row in range(9):
        values = [board.cells[row][c].value for c in range(9)]
        seen = set()
        for v in values:
            if v in seen:
                errors.append(f"Duplicate {v} in row {row}")
            seen.add(v)
    
    # Check columns
    for col in range(9):
        values = [board.cells[r][col].value for r in range(9)]
        seen = set()
        for v in values:
            if v in seen:
                errors.append(f"Duplicate {v} in col {col}")
            seen.add(v)
    
    # Check 3x3 boxes
    for box_row in range(3):
        for box_col in range(3):
            values = []
            for r in range(3):
                for c in range(3):
                    values.append(board.cells[box_row*3+r][box_col*3+c].value)
            seen = set()
            for v in values:
                if v in seen:
                    errors.append(f"Duplicate {v} in box ({box_row},{box_col})")
                seen.add(v)
    
    # Check all cells filled
    for row in range(9):
        for col in range(9):
            if board.cells[row][col].value is None:
                errors.append(f"Cell ({row},{col}) is empty")
    
    return len(errors) == 0, errors


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1:
        if sys.argv[1] == "--demo":
            demo_step_by_step()
        elif sys.argv[1] == "--benchmark":
            run_benchmark()
        elif sys.argv[1] == "--interactive":
            interactive_solver()
        else:
            print(f"Unknown argument: {sys.argv[1]}")
            print("Usage: python sudoku_solver.py [--demo|--benchmark|--interactive]")
    else:
        run_benchmark()
