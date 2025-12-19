package com.ashop.services.impl;

import com.ashop.dao.SupplierDAO;
import com.ashop.dao.impl.SupplierDAOImpl;
import com.ashop.entity.Supplier;
import com.ashop.services.SupplierService;
import java.util.List;

public class SupplierServiceImpl implements SupplierService {
    private final SupplierDAO supplierDAO = new SupplierDAOImpl();

    @Override
    public Supplier findById(int id) {
        return supplierDAO.findById(id);
    }

    @Override
    public List<Supplier> findAll() {
        return supplierDAO.findAll();
    }

    @Override
    public Supplier saveOrUpdate(Supplier supplier) {
        if (supplier.getSupplierId() == null) return supplierDAO.create(supplier);
        return supplierDAO.update(supplier);
    }

    @Override
    public boolean delete(int id) {
        Supplier s = supplierDAO.findById(id);
        if (s != null) {
            s.setStatus(false);
            supplierDAO.update(s);
            return true;
        }
        return false;
    }
}
