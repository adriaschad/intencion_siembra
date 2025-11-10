import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import './App.css';
import Dashboard from './pages/Dashboard';
import PlantingForms from './pages/PlantingForms';
import Varieties from './pages/Varieties';

function App() {
  return (
    <Router>
      <div>
        <header className="header">
          <div className="container">
            <h1>🌱 Sistema de Intención de Siembra</h1>
          </div>
        </header>

        <nav className="nav">
          <div className="container">
            <ul className="nav-list">
              <li><Link to="/">Dashboard</Link></li>
              <li><Link to="/planting-forms">Boletas de Siembra</Link></li>
              <li><Link to="/varieties">Variedades</Link></li>
            </ul>
          </div>
        </nav>

        <main className="container">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/planting-forms" element={<PlantingForms />} />
            <Route path="/varieties" element={<Varieties />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;
