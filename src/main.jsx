import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import ComplianceOSMVP from './App.jsx'
import LandingPage from './LandingPage.jsx'
import PitchPage from './PitchPage.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/pitch" element={<PitchPage />} />
        <Route path="/app" element={<ComplianceOSMVP />} />
        <Route path="/app/*" element={<ComplianceOSMVP />} />
      </Routes>
    </BrowserRouter>
  </React.StrictMode>,
)

