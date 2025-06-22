# csi-sql-week5
# 📚 Subject Change Request Tracking – MySQL Stored Procedure

This project solves a real-world college use case using MySQL:  
Tracking subject change requests made by students while preserving their subject change history.

---

## 🧩 Problem Statement

Colleges often allow students to switch their open elective subjects at the beginning of the academic year. The system should:

- Maintain a complete **history** of all subjects allotted to a student.
- Mark only **one subject as active** at a time (`Is_valid = 1`).
- Process incoming **change requests** from students and update the database accordingly.

- ## ⚙️ What the Procedure Does

1. Loops through each record in `SubjectRequest`.
2. If the student **already has subjects**:
   - If the requested subject is **different** from the current one:
     - Marks the current one as invalid (`Is_valid = 0`)
     - Inserts the new one as valid (`Is_valid = 1`)
3. If the student is **not present** in `SubjectAllotments`:
   - Inserts the requested subject directly as valid.

---

## 💡 Highlights

- Used `IF NOT EXISTS` to make the script **idempotent** (safe to rerun).
- Safe cursor-based procedure designed in **MySQL**.
- Ideal for real-world systems needing **history tracking** and **safe updates**.
