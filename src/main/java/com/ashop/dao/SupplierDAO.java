package com.ashop.dao;

import com.ashop.entity.Supplier;
import java.util.List;

public interface SupplierDAO {
    Supplier findById(int id);
    List<Supplier> findAll();
    Supplier create(Supplier supplier);
    Supplier update(Supplier supplier);
    void remove(Supplier supplier);
}
