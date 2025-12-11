package com.ashop.controllers.admin;

import com.ashop.dao.StatisticsDAO;
import com.ashop.dao.impl.StatisticsDAOImpl;
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
import java.util.List;
import java.util.Map;

@WebServlet("/admin/api/statistics/export")
public class ExportStatisticsCsvServlet extends HttpServlet {
    private StatisticsDAO statsDao = new StatisticsDAOImpl();

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
            resp.setContentType("text/plain;charset=UTF-8");
            resp.getWriter().println("Invalid period parameters: " + e.getMessage());
            return;
        }

        resp.setContentType("text/csv;charset=UTF-8");
        String fileName = "statistics.csv";
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        try (PrintWriter out = resp.getWriter()) {
            if (action == null || "inventory".equalsIgnoreCase(action)) {
                out.println("productId,productName,quantity");
                List<Object[]> rows = statsDao.getInventory();
                for (Object[] r : rows) {
                    out.printf("%s,%s,%s\n", safeCsv(r[0]), safeCsv(r[1]), safeCsv(r[2]));
                }
                return;
            }

            if ("salesProduct".equalsIgnoreCase(action)) {
                out.println("productId,productName,totalQty,totalRevenue");
                List<Object[]> rows = statsDao.getSalesByProduct(start, end);
                for (Object[] r : rows) {
                    out.printf("%s,%s,%s,%s\n", safeCsv(r[0]), safeCsv(r[1]), safeCsv(r[2]), safeCsv(r[3]));
                }
                return;
            }

            if ("salesCustomer".equalsIgnoreCase(action)) {
                out.println("userId,fullName,totalQty,totalRevenue");
                List<Object[]> rows = statsDao.getSalesByCustomer(start, end);
                for (Object[] r : rows) {
                    out.printf("%s,%s,%s,%s\n", safeCsv(r[0]), safeCsv(r[1]), safeCsv(r[2]), safeCsv(r[3]));
                }
                return;
            }

            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.println("Unknown action: " + action);
        }
    }

    private String safeCsv(Object o) {
        if (o == null) return "";
        String s = String.valueOf(o);
        if (s.contains(",") || s.contains("\n") || s.contains("\r") || s.contains("\"")) {
            s = s.replace("\"", "\"\"");
            return "\"" + s + "\"";
        }
        return s;
    }

    private int parseIntOrDefault(String s, int def) { try { return Integer.parseInt(s); } catch (Exception e) { return def; } }
}
