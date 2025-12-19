package com.ashop.services;

import com.ashop.entity.Supplier;
import java.util.List;

public interface SupplierService {
    Supplier findById(int id);
    List<Supplier> findAll();
    Supplier saveOrUpdate(Supplier supplier);
    boolean delete(int id);
}
