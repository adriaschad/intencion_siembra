import React, { useState, useEffect } from 'react';
import { varietyService } from '../services';

function Varieties() {
  const [varieties, setVarieties] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [formData, setFormData] = useState({
    name: '',
    averageCycleDays: '',
    isPollinizer: false,
    description: ''
  });

  useEffect(() => {
    fetchVarieties();
  }, []);

  const fetchVarieties = async () => {
    try {
      setLoading(true);
      const response = await varietyService.getAll();
      setVarieties(response.data);
      setError(null);
    } catch (err) {
      setError('Error al cargar las variedades: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editingId) {
        await varietyService.update(editingId, formData);
      } else {
        await varietyService.create(formData);
      }
      
      setShowForm(false);
      setEditingId(null);
      setFormData({ name: '', averageCycleDays: '', isPollinizer: false, description: '' });
      fetchVarieties();
      alert(editingId ? 'Variedad actualizada' : 'Variedad creada exitosamente');
    } catch (err) {
      alert('Error al guardar: ' + err.message);
    }
  };

  const handleEdit = (variety) => {
    setFormData({
      name: variety.name,
      averageCycleDays: variety.averageCycleDays,
      isPollinizer: variety.isPollinizer,
      description: variety.description || ''
    });
    setEditingId(variety._id);
    setShowForm(true);
  };

  const handleDelete = async (id) => {
    if (window.confirm('¿Está seguro de eliminar esta variedad?')) {
      try {
        await varietyService.delete(id);
        fetchVarieties();
        alert('Variedad eliminada exitosamente');
      } catch (err) {
        alert('Error al eliminar: ' + err.message);
      }
    }
  };

  if (loading) return <div className="loading">Cargando...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
        <h2>Variedades</h2>
        <button 
          className="button"
          onClick={() => {
            setShowForm(true);
            setEditingId(null);
            setFormData({ name: '', averageCycleDays: '', isPollinizer: false, description: '' });
          }}
        >
          + Nueva Variedad
        </button>
      </div>

      {showForm && (
        <div className="card">
          <h3>{editingId ? 'Editar Variedad' : 'Nueva Variedad'}</h3>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Nombre *</label>
              <input
                type="text"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                required
              />
            </div>

            <div className="form-group">
              <label>Ciclo Promedio (días) *</label>
              <input
                type="number"
                min="1"
                value={formData.averageCycleDays}
                onChange={(e) => setFormData({ ...formData, averageCycleDays: e.target.value })}
                required
              />
            </div>

            <div className="form-group">
              <label>
                <input
                  type="checkbox"
                  checked={formData.isPollinizer}
                  onChange={(e) => setFormData({ ...formData, isPollinizer: e.target.checked })}
                />
                Es Polinizador (no se incluirá en totales de área)
              </label>
            </div>

            <div className="form-group">
              <label>Descripción</label>
              <textarea
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              />
            </div>

            <div className="button-group">
              <button type="submit" className="button">
                {editingId ? 'Actualizar' : 'Crear'}
              </button>
              <button 
                type="button" 
                className="button button-secondary"
                onClick={() => {
                  setShowForm(false);
                  setEditingId(null);
                  setFormData({ name: '', averageCycleDays: '', isPollinizer: false, description: '' });
                }}
              >
                Cancelar
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="card">
        <table className="table">
          <thead>
            <tr>
              <th>Nombre</th>
              <th>Ciclo (días)</th>
              <th>Tipo</th>
              <th>Descripción</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {varieties.map((variety) => (
              <tr key={variety._id}>
                <td><strong>{variety.name}</strong></td>
                <td>{variety.averageCycleDays}</td>
                <td>
                  {variety.isPollinizer ? (
                    <span className="status-badge status-pending">Polinizador</span>
                  ) : (
                    <span className="status-badge status-approved">Producción</span>
                  )}
                </td>
                <td>{variety.description || '-'}</td>
                <td>
                  <div className="button-group">
                    <button 
                      className="button"
                      onClick={() => handleEdit(variety)}
                      style={{ padding: '5px 10px', fontSize: '12px' }}
                    >
                      Editar
                    </button>
                    <button 
                      className="button button-danger"
                      onClick={() => handleDelete(variety._id)}
                      style={{ padding: '5px 10px', fontSize: '12px' }}
                    >
                      Eliminar
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Varieties;
