import React, { useState, useEffect } from 'react';
import { plantingFormService, varietyService } from '../services';

function PlantingForms() {
  const [forms, setForms] = useState([]);
  const [varieties, setVarieties] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedForm, setSelectedForm] = useState(null);
  const [showApproveModal, setShowApproveModal] = useState(false);
  const [showRectifyModal, setShowRectifyModal] = useState(false);
  const [approvalData, setApprovalData] = useState({
    approvedBy: '',
    observations: '',
    photos: []
  });
  const [newArea, setNewArea] = useState('');

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      const [formsRes, varietiesRes] = await Promise.all([
        plantingFormService.getAll(),
        varietyService.getAll()
      ]);
      setForms(formsRes.data);
      setVarieties(varietiesRes.data);
      setError(null);
    } catch (err) {
      setError('Error al cargar los datos: ' + err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleApprove = async (formId) => {
    setSelectedForm(forms.find(f => f._id === formId));
    setShowApproveModal(true);
  };

  const submitApproval = async (e) => {
    e.preventDefault();
    try {
      const formData = new FormData();
      formData.append('approvedBy', approvalData.approvedBy);
      if (approvalData.observations) {
        formData.append('observations', approvalData.observations);
      }
      
      // Add photos
      for (let i = 0; i < approvalData.photos.length; i++) {
        formData.append('approvalPhotos', approvalData.photos[i]);
      }

      await plantingFormService.approve(selectedForm._id, formData);
      
      setShowApproveModal(false);
      setApprovalData({ approvedBy: '', observations: '', photos: [] });
      fetchData();
      alert('Boleta aprobada exitosamente');
    } catch (err) {
      alert('Error al aprobar la boleta: ' + err.message);
    }
  };

  const handleRectify = async (formId) => {
    const form = forms.find(f => f._id === formId);
    setSelectedForm(form);
    setNewArea(form.area.toString());
    setShowRectifyModal(true);
  };

  const submitRectification = async (e) => {
    e.preventDefault();
    try {
      await plantingFormService.rectifyArea(selectedForm._id, parseFloat(newArea));
      setShowRectifyModal(false);
      setNewArea('');
      fetchData();
      alert('Área rectificada exitosamente');
    } catch (err) {
      alert('Error al rectificar el área: ' + err.message);
    }
  };

  const getStatusBadge = (status) => {
    const statusMap = {
      pending: { class: 'status-pending', text: 'Pendiente' },
      approved: { class: 'status-approved', text: 'Aprobado' },
      rejected: { class: 'status-rejected', text: 'Rechazado' },
      harvested: { class: 'status-approved', text: 'Cosechado' }
    };
    const statusInfo = statusMap[status] || statusMap.pending;
    return <span className={`status-badge ${statusInfo.class}`}>{statusInfo.text}</span>;
  };

  if (loading) return <div className="loading">Cargando...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div>
      <h2>Boletas de Siembra</h2>

      <div className="card">
        <table className="table">
          <thead>
            <tr>
              <th>Finca</th>
              <th>Lote</th>
              <th>Variedad</th>
              <th>Área (ha)</th>
              <th>Fecha Siembra</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {forms.map((form) => (
              <tr key={form._id}>
                <td>{form.farmName}</td>
                <td>{form.lotNumber}</td>
                <td>{form.variety?.name || 'N/A'}</td>
                <td>
                  {form.area}
                  {form.area !== form.originalArea && (
                    <small style={{ color: '#999', display: 'block' }}>
                      (Original: {form.originalArea})
                    </small>
                  )}
                </td>
                <td>{new Date(form.plantingDate).toLocaleDateString()}</td>
                <td>{getStatusBadge(form.status)}</td>
                <td>
                  <div className="button-group">
                    {form.status === 'pending' && (
                      <button 
                        className="button button-secondary"
                        onClick={() => handleApprove(form._id)}
                        style={{ padding: '5px 10px', fontSize: '12px' }}
                      >
                        Aprobar
                      </button>
                    )}
                    <button 
                      className="button"
                      onClick={() => handleRectify(form._id)}
                      style={{ padding: '5px 10px', fontSize: '12px' }}
                    >
                      Rectificar Área
                    </button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Approval Modal */}
      {showApproveModal && (
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          backgroundColor: 'rgba(0,0,0,0.5)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 1000
        }}>
          <div className="card" style={{ maxWidth: '500px', width: '90%', maxHeight: '90vh', overflow: 'auto' }}>
            <h3>Aprobar Boleta de Siembra</h3>
            <p><strong>Finca:</strong> {selectedForm?.farmName}</p>
            <p><strong>Lote:</strong> {selectedForm?.lotNumber}</p>
            
            <form onSubmit={submitApproval}>
              <div className="form-group">
                <label>Aprobado por *</label>
                <input
                  type="text"
                  value={approvalData.approvedBy}
                  onChange={(e) => setApprovalData({ ...approvalData, approvedBy: e.target.value })}
                  required
                />
              </div>

              <div className="form-group">
                <label>Observaciones</label>
                <textarea
                  value={approvalData.observations}
                  onChange={(e) => setApprovalData({ ...approvalData, observations: e.target.value })}
                />
              </div>

              <div className="form-group">
                <label>Fotos del Avance</label>
                <input
                  type="file"
                  accept="image/*"
                  multiple
                  onChange={(e) => setApprovalData({ ...approvalData, photos: Array.from(e.target.files) })}
                />
                {approvalData.photos.length > 0 && (
                  <p style={{ marginTop: '5px', color: '#666', fontSize: '14px' }}>
                    {approvalData.photos.length} foto(s) seleccionada(s)
                  </p>
                )}
              </div>

              <div className="button-group">
                <button type="submit" className="button">
                  Aprobar con Visto Bueno
                </button>
                <button 
                  type="button" 
                  className="button button-secondary"
                  onClick={() => {
                    setShowApproveModal(false);
                    setApprovalData({ approvedBy: '', observations: '', photos: [] });
                  }}
                >
                  Cancelar
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Rectify Modal */}
      {showRectifyModal && (
        <div style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          backgroundColor: 'rgba(0,0,0,0.5)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 1000
        }}>
          <div className="card" style={{ maxWidth: '400px', width: '90%' }}>
            <h3>Rectificar Área</h3>
            <p><strong>Finca:</strong> {selectedForm?.farmName}</p>
            <p><strong>Lote:</strong> {selectedForm?.lotNumber}</p>
            <p><strong>Área Actual:</strong> {selectedForm?.area} ha</p>
            <p><strong>Área Original:</strong> {selectedForm?.originalArea} ha</p>
            
            <form onSubmit={submitRectification}>
              <div className="form-group">
                <label>Nueva Área (hectáreas) *</label>
                <input
                  type="number"
                  step="0.01"
                  min="0"
                  value={newArea}
                  onChange={(e) => setNewArea(e.target.value)}
                  required
                />
              </div>

              <div className="button-group">
                <button type="submit" className="button">
                  Rectificar
                </button>
                <button 
                  type="button" 
                  className="button button-secondary"
                  onClick={() => {
                    setShowRectifyModal(false);
                    setNewArea('');
                  }}
                >
                  Cancelar
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

export default PlantingForms;
