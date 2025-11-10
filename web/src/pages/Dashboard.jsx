import React, { useState, useEffect } from 'react';
import { plantingFormService } from '../services';

function Dashboard() {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchDashboard();
  }, []);

  const fetchDashboard = async () => {
    try {
      setLoading(true);
      const response = await plantingFormService.getDashboard();
      setStats(response.data);
      setError(null);
    } catch (err) {
      setError('Error al cargar el dashboard: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="loading">Cargando...</div>;
  if (error) return <div className="error">{error}</div>;
  if (!stats) return null;

  return (
    <div>
      <h2>Dashboard de Intención de Siembra</h2>

      <div className="dashboard-grid">
        <div className="stat-card">
          <h3>Total de Boletas</h3>
          <div className="value">{stats.totalForms}</div>
        </div>

        <div className="stat-card">
          <h3>Pendientes</h3>
          <div className="value">{stats.pendingForms}</div>
          <div className="label">Sin aprobar</div>
        </div>

        <div className="stat-card">
          <h3>Aprobadas</h3>
          <div className="value">{stats.approvedForms}</div>
          <div className="label">Visto Bueno</div>
        </div>

        <div className="stat-card">
          <h3>Área Total (sin polinizadores)</h3>
          <div className="value">{stats.totalArea.toFixed(2)}</div>
          <div className="label">hectáreas</div>
        </div>
      </div>

      <div className="card">
        <h3>Desglose por Variedad</h3>
        <table className="table">
          <thead>
            <tr>
              <th>Variedad</th>
              <th>Área (ha)</th>
              <th>Cantidad de Boletas</th>
              <th>Tipo</th>
            </tr>
          </thead>
          <tbody>
            {Object.entries(stats.varietyBreakdown).map(([variety, data]) => (
              <tr key={variety}>
                <td>{variety}</td>
                <td>{data.area.toFixed(2)}</td>
                <td>{data.count}</td>
                <td>
                  {data.isPollinizer ? (
                    <span className="status-badge status-pending">Polinizador</span>
                  ) : (
                    <span className="status-badge status-approved">Producción</span>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {stats.pollinizers.length > 0 && (
        <div className="card">
          <h3>Variedades Polinizadoras (no incluidas en total)</h3>
          <table className="table">
            <thead>
              <tr>
                <th>Variedad</th>
                <th>Área (ha)</th>
              </tr>
            </thead>
            <tbody>
              {stats.pollinizers.map((p, index) => (
                <tr key={index}>
                  <td>{p.variety}</td>
                  <td>{p.area.toFixed(2)}</td>
                </tr>
              ))}
            </tbody>
          </table>
          <p style={{ marginTop: '15px', color: '#666', fontSize: '14px' }}>
            <strong>Nota:</strong> Las variedades polinizadoras representan {stats.totalAreaWithPollinizers - stats.totalArea} ha adicionales 
            que no se contabilizan en el área total de producción.
          </p>
        </div>
      )}
    </div>
  );
}

export default Dashboard;
