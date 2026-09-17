# Ghi chú rà soát thesis.typ — để tự revise

_Cập nhật lần 2 — đã có kết quả so sánh code/notebook (mục 0 bên dưới)._

## 0. NGHIÊM TRỌNG: `thesis_code_04_perf.py` và `thesis_code_05_simrf.py` không khớp với bất kỳ notebook nào

Đây là phát hiện quan trọng nhất, liên quan trực tiếp tới mục 1 bên dưới. Đã grep toàn bộ 3 file `.ipynb` tìm các hàm/thư viện mà 2 file này dùng (`discover_performance_dfg`, `simpy`, `RandomForest`, `sklearn`, `classify_resource`, `automation`, `roc_auc`, `LabelEncoder`, `train_test_split`) — **không có kết quả nào** trong cả 3 notebook. `03_advanced_analysis.ipynb` kết thúc ở cell KPI-summary (cell 20); sau đó chỉ còn 1 cell markdown, không có code nào cho performance DFG, automation rate, OCDFG, SimPy simulation, hay Random Forest.

- [ ] **Xác nhận lại:** có tồn tại notebook thứ 4 nào chưa được lưu/chưa đưa vào thư mục không? Nếu file `thesis_code_04_perf.py` và `thesis_code_05_simrf.py` là code bạn *đã* chạy ở đâu đó (notebook khác, hoặc chạy trực tiếp không lưu notebook), cần tìm và lưu lại notebook đó để đảm bảo reproducibility.
- [ ] Nếu **không tìm lại được** notebook gốc, cần chạy lại 2 file `.py` này để tự xác nhận các con số đang được trình bày trong thesis là đúng thật:
  - Automation rate 9.6% (dòng 1430)
  - Bảng top-10 slowest transitions (dòng 1398-1409)
  - OCDFG pair counts (dòng 1456-1473)
  - Kết quả SimPy simulation (phần "Discrete-Event Simulation")
  - AUC-ROC và feature importance của Random Forest (phần "Predictive Process Monitoring")
- [ ] API/tên cột dùng trong 2 file này đều là hàm pm4py thật và cột dữ liệu thật (không phải "bịa" cú pháp) — chỉ là **chưa có bằng chứng đã thực sự chạy ra đúng những con số đang trình bày**.

## 0b. Bug thật trong code — cắt dòng include sai vị trí

- [ ] **`thesis_code_03_advanced.py`**: dòng 133 (`n_train = int(len(classic_log)*0.70); train_log = classic_log[:n_train]`) bị bỏ sót giữa 2 đoạn include (`115-132` và `134-138`). Đoạn code hiển thị ở `134-138` dùng biến `train_log` nhưng người đọc không hề thấy nó được định nghĩa ở đâu → sửa lại range include hoặc thêm dòng 133 vào.
- [ ] **`thesis_code_05_simrf.py`**: dòng 41 (`df_results = pd.DataFrame(...)`) bị bỏ sót giữa `14-40` và `42-63`. Đoạn `78-89` dùng `df_results["approvers"]`, `df_results["mean_tt"]`,... nhưng biến này chưa từng được định nghĩa trong đoạn code người đọc thấy → sửa lại range include.

## 0c. Sai lệch dữ liệu trong `thesis_code_03_advanced.py`

- [ ] Dòng 1-11 tính `variants`/`total_cases` trực tiếp từ `classic_log` **chưa lọc** (43,903 cases, 53,198 events) — thiếu bộ lọc `DATE_MIN >= 2018-01-01` mà notebook 3 (cell 4) có áp dụng (lọc còn 43,898 cases, 53,187 events, loại 5 case outlier). Nhưng bảng KPI ở dòng 84-100 (776 variants, coverage 85.3%/90.5%, 4864/3997 cases, 36.67/17.89/125.98 ngày) lại khớp chính xác với **kết quả đã lọc** của notebook. Nghĩa là: nếu chạy đúng y hệt code đang hiển thị trong thesis (dòng 1-11), sẽ **không** ra được các con số ở bảng KPI. Cần thêm bước lọc ngày vào `thesis_code_03_advanced.py` cho khớp.

## 0d. Lỗi nhỏ

- [ ] `thesis_code_05_simrf.py` dòng 82: hardcode "BPI 2019 mean" = `36.77`, nhưng giá trị đã xác nhận từ notebook là `36.67` — lệch số nhỏ, sửa lại cho khớp.
- [ ] `thesis_code_03/04/05` đều tự tách `train_log` bằng cách cắt trực tiếp `classic_log[:n_train]` (không sort theo thời gian) cho một lần discover Petri net phụ, khác với cách notebook 2 làm đúng (`case_start.sort_values()` rồi mới split). Ảnh hưởng thấp vì kết quả (places/transitions/arcs) không được in ra hay dùng tiếp ở phần 03, nhưng nên đồng nhất code cho gọn.

## File sạch, không cần sửa

- `thesis_code_01_synthetic.py` — khớp chính xác với `01_toy_dataset.ipynb` (CV 0.04, mean 120.0 min,...).
- `thesis_code_02_bpi2019.py` — khớp chính xác với `02_bpi2019_pipeline.ipynb` (43,898 cases, split 30,728/6,584/6,586, Petri net 95/154/334).

## 1. Không khớp số lượng notebook (ưu tiên cao)

**Vấn đề:** Văn bản mô tả **5 notebook Jupyter riêng biệt**, nhưng thư mục chỉ có **3 file `.ipynb`** (`01_toy_dataset.ipynb`, `02_bpi2019_pipeline.ipynb`, `03_advanced_analysis.ipynb`).

**Các chỗ cần sửa trong `thesis.typ`:**

- [ ] **Dòng 147** — "*Five Jupyter notebooks are developed...* The first notebook uses a small, hand-built dataset... The remaining four notebooks..." → mô tả 5 notebook riêng biệt.
- [ ] **Dòng 161** — "*This chapter walks through five practical Jupyter notebooks*... The fourth notebook adds a performance perspective... The fifth notebook completes the cycle..." → cùng vấn đề.
- [ ] **Dòng 1380** — "The third notebook takes the analysis further..." (chỉ mô tả 03_advanced_analysis, ổn).
- [ ] **Dòng 1489** — "*The fourth and fifth notebooks* shift the analysis... Notebook 4 uses discrete-event simulation... Notebook 5 introduces predictive monitoring..." → thực chất cả hai phần này (SimPy simulation + Random Forest) đều nằm trong **cùng một file** `03_advanced_analysis.ipynb`, tương ứng với `thesis_code_04_perf.py` và `thesis_code_05_simrf.py` (chỉ là 2 file .py tách riêng để include code vào thesis, không phải 2 notebook riêng).

**Gợi ý sửa:** Đổi cách diễn đạt từ "5 notebooks" → "3 notebooks, tổ chức thành 5 giai đoạn phân tích" (hoặc tương tự), và sửa lại các đoạn mô tả "notebook thứ tư/thứ năm" thành "phần thứ tư/thứ năm của notebook thứ ba" (hay "the third notebook continues with..."). Đây là điểm giáo sư dễ kiểm tra qua tính reproducibility (đếm số file thực tế).

## 2. Thiếu trích dẫn cho 13/19 tài liệu trong `refs.bib`

Các nguồn này đã có sẵn trong bibliography nhưng chưa được `@cite` ở đúng chỗ nội dung liên quan:

- [ ] **Dòng ~311–326 (Thuật toán Alpha)** → thêm `@vanderAalst2004alpha`
- [ ] **Dòng ~328–358 (Inductive Miner)** → thêm `@leemans2013inductive` (và cân nhắc `@leemans2014infrequent` nếu đúng ngữ cảnh)
- [ ] **Dòng ~438–466 (Alignment-based conformance)** → thêm `@adriansyah2015alignment`
- [ ] **Dòng ~507–518 (OCEL section)** → thêm `@ghahfarokhi2021ocel` và `@vanderAalst2019objectcentric`
- [ ] **Dòng ~580–598 (PM4Py)** → thêm `@berti2019pm4py` và/hoặc `@berti2023pm4py`
- [ ] **Dòng ~620 (Heuristics Miner, nhắc trong phần PMLab)** → thêm `@weijters2006heuristics`
- [ ] **Dòng ~608–614 (Simod)** → thêm `@camargo2020simod`
- [ ] **Dòng ~740 (Pandas)** → thêm `@pandas2020`
- [ ] **Dòng ~750 (Scikit-Learn)** → thêm `@scikit2011`
- [ ] Cân nhắc thêm `@murata1989petri` ở phần định nghĩa formal Petri net (dòng ~292–309, nhắc "reachability and soundness" ở dòng 422)

**Lưu ý:** `janssenswillen2019bupar` và `teinemaa2019outcome` đã được cite đúng chỗ rồi, không cần sửa.

## 3. Đã kiểm tra và OK (không cần sửa)

- [x] Compile thành công, không lỗi/warning (đã fix `refs.yml`→`refs.bib` ở bước trước).
- [x] Tất cả cross-reference (`@fig-...`, `@tab-...`, `@chap-...`) đều resolve đúng — Typst sẽ báo lỗi compile nếu có ref hỏng, nên phần này an toàn.
- [x] Không có text placeholder còn sót (TODO, FIXME, lorem ipsum...).
- [x] Các con số lặp lại nhiều nơi khớp nhau: 43,898 cases = 30,728 + 6,584 + 6,586 (train/val/test split); 95 places / 154 transitions / 334 arcs nhất quán giữa các đoạn.
- [x] Không phát hiện lỗi chính tả tiếng Anh phổ biến.

---

_Đã kiểm tra xong toàn bộ: nội dung văn bản (mục 1-3) và so sánh code/notebook (mục 0). Không còn phần nào đang chạy nền._
