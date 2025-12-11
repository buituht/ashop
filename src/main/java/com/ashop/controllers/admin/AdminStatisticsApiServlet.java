package com.ashop.controllers.admin;

import com.ashop.dao.StatisticsDAO;
import com.ashop.dao.impl.StatisticsDAOImpl;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/api/statistics")
public class AdminStatisticsApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StatisticsDAO statsDao = new StatisticsDAOImpl();
    private Gson gson = new GsonBuilder().setPrettyPrinting().create();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String period = req.getParameter("period");

        LocalDateTime start;
        LocalDateTime end;
        try {
            if ("range".equalsIgnoreCase(period)) {
                String startStr = req.getParameter("startDate");
                String endStr = req.getParameter("endDate");
                DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                LocalDate s = (startStr != null) ? LocalDate.parse(startStr, fmt) : LocalDate.now().withDayOfMonth(1);
                LocalDate e = (endStr != null) ? LocalDate.parse(endStr, fmt) : LocalDate.now();
                start = s.atStartOfDay();
                end = e.plusDays(1).atStartOfDay().minusNanos(1);
            } else if ("quarter".equalsIgnoreCase(period)) {
                int year = parseIntOrDefault(req.getParameter("year"), LocalDate.now().getYear());
                int q = parseIntOrDefault(req.getParameter("quarter"), 1);
                int startMonth = (Math.max(1, Math.min(4, q)) - 1) * 3 + 1;
                YearMonth ym = YearMonth.of(year, startMonth);
                start = ym.atDay(1).atStartOfDay();
                end = ym.plusMonths(3).atDay(1).atStartOfDay().minusNanos(1);
            } else if ("year".equalsIgnoreCase(period)) {
                int year = parseIntOrDefault(req.getParameter("year"), LocalDate.now().getYear());
                start = LocalDate.of(year, 1, 1).atStartOfDay();
                end = start.plusYears(1).minusNanos(1);
            } else {
                int year = parseIntOrDefault(req.getParameter("year"), LocalDate.now().getYear());
                int month = parseIntOrDefault(req.getParameter("month"), LocalDate.now().getMonthValue());
                YearMonth ym = YearMonth.of(year, month);
                start = ym.atDay(1).atStartOfDay();
                end = ym.plusMonths(1).atDay(1).atStartOfDay().minusNanos(1);
            }
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("application/json;charset=UTF-8");
            try (PrintWriter out = resp.getWriter()) {
                out.print(gson.toJson(Map.of("error", "Invalid period parameters", "detail", e.getMessage())));
            }
            return;
        }

        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            if ("inventory".equalsIgnoreCase(action) || action == null) {
                List<Object[]> rows = statsDao.getInventory();
                List<Map<String, Object>> outList = new ArrayList<>();
                for (Object[] r : rows) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("productId", r[0]);
                    m.put("productName", r[1]);
                    m.put("quantity", r[2]); // native query trả về stock_quantity
                    outList.add(m);
                }
                // add debug info
                long totalProducts = statsDao.countProducts();
                // server-side debug logging
                System.out.println("[STAT] totalProducts=" + totalProducts + ", rowsReturned=" + rows.size());
                if (!rows.isEmpty()) {
                    Object[] sample = rows.get(0);
                    System.out.println("[STAT] sample row types: ");
                    for (int i=0;i<sample.length;i++) System.out.println("  col"+i+":"+ (sample[i]==null?"null":sample[i].getClass().getName() + "=" + sample[i]));
                }
                Map<String,Object> debug = new HashMap<>();
                debug.put("debug_countProducts", totalProducts);
                Map<String,Object> wrapper = new HashMap<>();
                wrapper.put("rows", outList);
                wrapper.put("debug", debug);
                out.print(gson.toJson(wrapper));
                return;
            }

            if ("salesProduct".equalsIgnoreCase(action)) {
                List<Object[]> rows = statsDao.getSalesByProduct(start, end);
                // debug logging for sales
                System.out.println("[STAT] salesProduct rowsReturned=" + (rows==null?0:rows.size()));
                if (rows != null && !rows.isEmpty()) {
                    Object[] s = rows.get(0);
                    System.out.println("[STAT] sales sample cols:");
                    for (int i=0;i<s.length;i++) System.out.println("  col"+i+":" + (s[i]==null?"null": s[i].getClass().getName() + "=" + s[i]));
                }
                List<Map<String, Object>> outList = new ArrayList<>();
                for (Object[] r : rows) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("productId", r[0]);
                    m.put("productName", r[1]);
                    m.put("totalQty", r[2]);
                    m.put("totalRevenue", r[3]);
                    outList.add(m);
                }
                out.print(gson.toJson(outList));
                return;
            }

            if ("salesCustomer".equalsIgnoreCase(action)) {
                List<Object[]> rows = statsDao.getSalesByCustomer(start, end);
                List<Map<String, Object>> outList = new ArrayList<>();
                for (Object[] r : rows) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("userId", r[0]);
                    m.put("fullName", r[1]);
                    m.put("totalQty", r[2]);
                    m.put("totalRevenue", r[3]);
                    outList.add(m);
                }
                out.print(gson.toJson(outList));
                return;
            }

            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(Map.of("error", "Unknown action", "action", action)));
        }
    }

    private int parseIntOrDefault(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}