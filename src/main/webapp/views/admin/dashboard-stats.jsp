<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Dashboard - Thống kê</title>
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* clean up debug elements for production UI */
        #inventory-raw-json { display: none !important; }
        .inventory-debug { display: none !important; }
        /* loading overlay */
        .spinner-sm { width:1rem; height:1rem; border-width:.15em }
    </style>
</head>
<body>
<div class="container mt-4">
    <h1>Thống kê</h1>

    <div class="row">
        <div class="col-md-4">
            <h4>Hàng tồn kho</h4>
            <div class="mb-2">
                <button id="exportInventory" class="btn btn-sm btn-outline-primary">Export CSV</button>
            </div>
            <div id="inventory-debug-info" class="mb-2 text-muted small"></div>
            <pre id="inventory-raw-json" style="display:none; white-space:pre-wrap; background:#f8f9fa; padding:10px; border:1px solid #eee;"></pre>
            <table class="table table-sm" id="inventoryTable">
                <thead>
                <tr><th>#</th><th>Sản phẩm</th><th>Số lượng</th></tr>
                </thead>
                <tbody></tbody>
            </table>
            <nav>
                <ul class="pagination" id="inventoryPager"></ul>
            </nav>
        </div>

        <div class="col-md-8">
            <h4>Doanh số theo sản phẩm</h4>
            <div class="d-flex mb-2 gap-2">
                <select id="periodType" class="form-select form-select-sm" style="width:150px;">
                    <option value="month">Tháng</option>
                    <option value="quarter">Quý</option>
                    <option value="year">Năm</option>
                    <option value="range">Khoảng</option>
                </select>
                <input type="month" id="monthPicker" class="form-control form-control-sm" />
                <select id="quarterPicker" class="form-select form-select-sm" style="width:120px; display:none;">
                    <option value="1">Quý 1</option>
                    <option value="2">Quý 2</option>
                    <option value="3">Quý 3</option>
                    <option value="4">Quý 4</option>
                </select>
                <input type="number" id="yearPicker" class="form-control form-control-sm" placeholder="Năm" style="width:100px; display:none;" />
                <input type="date" id="startDate" class="form-control form-control-sm" style="display:none;" />
                <input type="date" id="endDate" class="form-control form-control-sm" style="display:none;" />
                <input type="number" id="topN" class="form-control form-control-sm" placeholder="Top N" style="width:100px;" />
                <button id="loadSales" class="btn btn-sm btn-primary">Tải</button>
                <button id="exportSales" class="btn btn-sm btn-outline-primary">Export CSV</button>
            </div>

            <canvas id="salesChart" height="160"></canvas>

            <table class="table table-sm mt-3" id="salesTable">
                <thead>
                <tr><th>#</th><th>Sản phẩm</th><th>Số lượng</th><th>Doanh thu</th></tr>
                </thead>
                <tbody></tbody>
            </table>

            <nav>
                <ul class="pagination" id="salesPager"></ul>
            </nav>
        </div>
    </div>
</div>

<script>
    const ctx = '${pageContext.request.contextPath}';
    // global JS error handler to surface errors on page (register first so it catches early errors)
    window.addEventListener('error', function (e) {
        const d = document.getElementById('inventory-debug-info');
        if (d) d.textContent = 'JS ERROR: ' + e.message + ' at ' + e.filename + ':' + e.lineno;
        console.error(e.error || e.message);
    });
    const ctxOrigin = window.location.origin + ctx; // helpful full path
    const ctxPath = ctx; // short
    const ctxFull = ctxOrigin;
    const ctxBase = ctxPath;
    const ctxStr = ctxPath;
    const ctxRoot = ctxPath;
    const ctx2 = ctxPath; // compatibility
    const ctx3 = ctxPath;
    const ctx4 = ctxPath;
    const ctx5 = ctxPath;
    const ctx6 = ctxPath;
    const ctx7 = ctxPath;
    const ctx8 = ctxPath;

    const ctxVariable = ctxPath; // use this to build URLs
    const ctxUrl = ctxPath;

    const ctxp = ctxPath;

    const ctxSafe = ctxPath;

    const contextPath = ctxPath;

    const jsContext = contextPath;

    const jsCtx = jsContext;

    const jsRoot = jsCtx;

    const root = jsRoot;

    const realCtx = root;

    const appCtx = realCtx;

    // Chart init
    let salesChart;
    try {
        const canvasEl = document.getElementById('salesChart');
        if (canvasEl && canvasEl.getContext) {
            const ctxCanvas = canvasEl.getContext('2d');
            if (typeof Chart !== 'undefined') {
                salesChart = new Chart(ctxCanvas, {type:'bar', data:{labels:[], datasets:[{label:'Doanh thu', data:[]} ]}, options:{}});
            } else {
                console.warn('Chart.js not available');
            }
        }
    } catch (e) {
        console.error('Chart init error', e);
    }

    // show appCtx for debugging
    // hide debug info in polished UI; keep minimal context for troubleshooting
    document.getElementById('inventory-debug-info').style.display = 'none';

    // format helpers
    const nf = new Intl.NumberFormat('vi-VN');
    const cf = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 });
    function formatNumber(n){ if(n==null || n==='') return ''; try{ return nf.format(Number(n)); }catch(e){ return n; } }
    function formatCurrency(n){ if(n==null || n==='') return ''; try{ return cf.format(Number(n)); }catch(e){ return n; } }

    function fetchInventory(page=1, pageSize=10) {
        fetch(appCtx + '/admin/api/statistics?action=inventory')
            .then(r => r.json()).then(data => {
                console.log('inventory raw', data);
                // hide raw JSON in polished UI
                // handle wrapper {rows, debug}
                const rows = data.rows ? data.rows : data;
                const debug = data.debug ? data.debug : {};
                // update debug info area with counts and sample
                const dbgArea = document.getElementById('inventory-debug-info');
                try {
                    const sample = rows && rows.length>0 ? rows[0] : null;
                    // minimal debug text kept but hidden by CSS
                    dbgArea.textContent = 'rows=' + (rows?rows.length:0) + ' | totalProducts=' + (debug.debug_countProducts||'n/a');
                } catch(e) { console.error(e); }
                // paging client-side
                const total = rows.length;
                const start = (page-1)*pageSize;
                const pageData = rows.slice(start, start+pageSize);
                const tbody = document.querySelector('#inventoryTable tbody'); tbody.innerHTML = '';
                pageData.forEach((row,i)=>{
                    const tr = document.createElement('tr');
                    const name = row.productName || row.product_name || row.productId || row[1] || ('#' + (row.productId||row[0]||''));
                    const qtyRaw = (row.quantity!=null? row.quantity : (row.qty!=null? row.qty : (row[2]!=null? row[2] : '')));
                    const qty = formatNumber(qtyRaw);
                    tr.innerHTML = '<td>' + (start+i+1) + '</td><td>' + name + '</td><td>' + qty + '</td>';
                    tbody.appendChild(tr);
                });
                if (total === 0) {
                    tbody.innerHTML = '<tr><td colspan="3" class="text-center text-muted">Không có sản phẩm tồn kho</td></tr>';
                }
                renderPager('inventoryPager', total, page, pageSize, fetchInventory);
                if (total === 0) {
                    const dbg = document.createElement('div'); dbg.className='text-muted small'; dbg.innerHTML = '<strong>DEBUG</strong>: totalProducts='+ (debug.debug_countProducts || 'n/a') +'<br/>API rows length='+rows.length+'; returned wrapper keys: '+Object.keys(data).join(', ');
                    const parent = document.querySelector('#inventoryTable').parentNode;
                    const existing = parent.querySelector('.inventory-debug');
                    if (existing) existing.remove();
                    dbg.classList.add('inventory-debug');
                    parent.insertBefore(dbg, document.querySelector('#inventoryTable').nextSibling);
                }
             }).catch(err=>{ console.error('inventory fetch error', err); document.querySelector('#inventoryTable tbody').innerHTML='<tr><td colspan="3">Không thể tải dữ liệu</td></tr>'; });
    }

    function fetchSales(page=1, pageSize=10) {
        const period = document.getElementById('periodType').value;
        const topN = parseInt(document.getElementById('topN').value) || 0;
        // show short loading state
        const salesTbody = document.querySelector('#salesTable tbody');
        salesTbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">Đang tải...</td></tr>';
         let params = new URLSearchParams();
         params.set('action','salesProduct');
         // Default to all-time range when no specific period selected
         let usePeriod = period;
         if (!usePeriod || (usePeriod==='month' && !document.getElementById('monthPicker').value)) {
             usePeriod = 'range';
         }
         params.set('period', usePeriod);
        if (period === 'month') {
            const val = document.getElementById('monthPicker').value;
            if (val) { const [y,m] = val.split('-'); params.set('year',y); params.set('month',m); }
        } else if (period === 'quarter') {
            params.set('quarter', document.getElementById('quarterPicker').value);
            params.set('year', document.getElementById('yearPicker').value || new Date().getFullYear());
        } else if (period === 'year') {
            params.set('year', document.getElementById('yearPicker').value || new Date().getFullYear());
        } else if (period === 'range') {
            params.set('startDate', document.getElementById('startDate').value);
            params.set('endDate', document.getElementById('endDate').value);
        }
        // If we switched to range by default and no dates provided, set wide range (all time)
        if (usePeriod === 'range') {
            if (!params.get('startDate')) params.set('startDate', '2000-01-01');
            if (!params.get('endDate')) {
                const d = new Date();
                params.set('endDate', d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0'));
            }
        }
        fetch(appCtx + '/admin/api/statistics?' + params.toString())
            .then(r=>r.json()).then(data=>{
                console.log('sales raw', data);
                let list = data;
                // normalize rows to objects with keys: productId, productName, totalQty, totalRevenue
                function normalizeRow(r) {
                    if (!r) return {productId:'', productName:'', totalQty:0, totalRevenue:0};
                    if (Array.isArray(r)) {
                        return { productId: r[0], productName: r[1], totalQty: r[2] || 0, totalRevenue: r[3] || 0 };
                    }
                    // r is object; map various possible key names
                    const productId = r.productId || r.product_id || r.id || r[0];
                    const productName = r.productName || r.product_name || r.name || r.title || r[1] || '';
                    const totalQty = r.totalQty || r.total_qty || r.qty || r.quantity || r[2] || 0;
                    const totalRevenue = r.totalRevenue || r.total_revenue || r.revenue || r.subtotal || r[3] || 0;
                    return { productId, productName, totalQty, totalRevenue };
                }
                if (Array.isArray(list)) {
                    list = list.map(normalizeRow);
                }
                 if (topN>0) list = list.slice(0, topN);
                 const total = list.length;
                 const start = (page-1)*pageSize;
                 const pageData = list.slice(start, start+pageSize);
                 const tbody = document.querySelector('#salesTable tbody'); tbody.innerHTML='';
                 const labels = [];
                 const revenues = [];
                 pageData.forEach((row,i)=>{
                     const tr = document.createElement('tr');
                     const name = row.productName || ('#' + (row.productId||''));
                     const qty = formatNumber(row.totalQty);
                     const revenue = formatCurrency(row.totalRevenue);
                     tr.innerHTML = '<td>' + (start+i+1) + '</td><td>' + name + '</td><td>' + qty + '</td><td>' + revenue + '</td>';
                     tbody.appendChild(tr);
                     labels.push(name);
                     revenues.push(Number(row.totalRevenue || 0));
                 });
                if (total === 0) {
                    tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">Không có dữ liệu doanh số</td></tr>';
                }
                 // update chart (if available)
                 if (salesChart) {
                    salesChart.data.labels = labels;
                    if (salesChart.data.datasets && salesChart.data.datasets[0]) salesChart.data.datasets[0].data = revenues;
                    salesChart.options = salesChart.options || {};
                    // tooltip format
                    salesChart.options.plugins = salesChart.options.plugins || {};
                    salesChart.options.plugins.tooltip = {callbacks: {label: function(context){ return formatCurrency(context.parsed.y); }}};
                    salesChart.update();
                }
                renderPager('salesPager', total, page, pageSize, fetchSales);
            }).catch(err=>{ console.error('sales fetch error', err); document.querySelector('#salesTable tbody').innerHTML='<tr><td colspan="4">Không thể tải dữ liệu</td></tr>'; });
    }

    function renderPager(pagerId, total, current, pageSize, onPage) {
        const pages = Math.max(1, Math.ceil(total/pageSize));
        const ul = document.getElementById(pagerId); ul.innerHTML='';
        for (let i=1;i<=pages;i++) {
            const li = document.createElement('li'); li.className='page-item '+(i===current?'active':'');
            const a = document.createElement('a'); a.className='page-link'; a.href='#'; a.textContent=i;
            a.addEventListener('click',(e)=>{ e.preventDefault(); onPage(i); });
            li.appendChild(a); ul.appendChild(li);
        }
    }

    document.getElementById('periodType').addEventListener('change', (e)=>{
        const v=e.target.value;
        document.getElementById('monthPicker').style.display = v==='month'? 'inline-block':'none';
        document.getElementById('quarterPicker').style.display = v==='quarter'? 'inline-block':'none';
        document.getElementById('yearPicker').style.display = (v==='year' || v==='quarter')? 'inline-block':'none';
        document.getElementById('startDate').style.display = v==='range'? 'inline-block':'none';
        document.getElementById('endDate').style.display = v==='range'? 'inline-block':'none';
    });

    document.getElementById('loadSales').addEventListener('click', ()=> fetchSales(1,10));
    document.getElementById('exportInventory').addEventListener('click', ()=>{
        window.location = appCtx + '/admin/api/statistics/export?action=inventory';
    });
    document.getElementById('exportSales').addEventListener('click', ()=>{
        const period = document.getElementById('periodType').value;
        let params = new URLSearchParams(); params.set('action','salesProduct'); params.set('period',period);
        if (period==='month') { const val=document.getElementById('monthPicker').value; if (val){const [y,m]=val.split('-'); params.set('year',y); params.set('month',m);} }
        if (period==='quarter'){ params.set('quarter',document.getElementById('quarterPicker').value); params.set('year',document.getElementById('yearPicker').value||new Date().getFullYear()); }
        if (period==='year'){ params.set('year',document.getElementById('yearPicker').value||new Date().getFullYear()); }
        if (period==='range'){ params.set('startDate',document.getElementById('startDate').value); params.set('endDate',document.getElementById('endDate').value); }
        window.location = appCtx + '/admin/api/statistics/export?' + params.toString();
    });

    // initial load
    fetchInventory(1,10);
    fetchSales(1,10);
</script>
</body>
</html>
