import api from './api';

export const varietyService = {
  getAll: () => api.get('/varieties'),
  getById: (id) => api.get(`/varieties/${id}`),
  create: (data) => api.post('/varieties', data),
  update: (id, data) => api.put(`/varieties/${id}`, data),
  delete: (id) => api.delete(`/varieties/${id}`),
};

export const plantingFormService = {
  getAll: (params) => api.get('/planting-forms', { params }),
  getById: (id) => api.get(`/planting-forms/${id}`),
  create: (data) => api.post('/planting-forms', data),
  update: (id, data) => api.put(`/planting-forms/${id}`, data),
  approve: (id, formData) => {
    return api.put(`/planting-forms/${id}/approve`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
  },
  rectifyArea: (id, area) => api.put(`/planting-forms/${id}/rectify-area`, { area }),
  confirmHarvest: (id, date) => api.put(`/planting-forms/${id}/confirm-harvest`, { confirmedHarvestDate: date }),
  getDashboard: (params) => api.get('/planting-forms/dashboard', { params }),
};

export const samplingFormService = {
  getAll: (params) => api.get('/sampling-forms', { params }),
  getById: (id) => api.get(`/sampling-forms/${id}`),
  create: (formData) => {
    return api.post('/sampling-forms', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
  },
  update: (id, formData) => {
    return api.put(`/sampling-forms/${id}`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
  },
  delete: (id) => api.delete(`/sampling-forms/${id}`),
};

export const replantingFormService = {
  getAll: (params) => api.get('/replanting-forms', { params }),
  getById: (id) => api.get(`/replanting-forms/${id}`),
  create: (data) => api.post('/replanting-forms', data),
  update: (id, data) => api.put(`/replanting-forms/${id}`, data),
  delete: (id) => api.delete(`/replanting-forms/${id}`),
};
