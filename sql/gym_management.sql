DROP TABLE class_booking CASCADE CONSTRAINTS;
DROP TABLE payments CASCADE CONSTRAINTS;
DROP TABLE fitness_classes CASCADE CONSTRAINTS;
DROP TABLE membership CASCADE CONSTRAINTS;
DROP TABLE membership_plans CASCADE CONSTRAINTS;
DROP TABLE trainers CASCADE CONSTRAINTS;
DROP TABLE members CASCADE CONSTRAINTS;

create table members(
member_id number(10) generated as identity constraint pk_members primary key,
full_name varchar2(60) constraint nn_members_full_name not null,
email varchar2(70),
phone varchar2(30),
join_date date default sysdate,
city varchar2(30)
);

create table membership_plans(
plan_id number(10) generated as identity constraint pk_membership_plans primary key,
plan_name varchar2(70) CONSTRAINT nn_plan_name NOT NULL,
duration_months number(10) CONSTRAINT nn_plan_duration NOT NULL,
price number(8,2) CONSTRAINT nn_plan_price NOT NULL constraint chk_membership_plans_price CHECK (price >= 0)
);

create table membership(
membership_id number(10) generated as identity constraint pk_membership primary key,
start_date date CONSTRAINT nn_membership_start_date NOT NULL,
end_date date,
membership_status varchar2(10)
CONSTRAINT chk_membership_status CHECK (membership_status IN ('Active', 'Expired', 'Pending'))
CONSTRAINT nn_membership_status NOT NULL,
member_id number(10)
constraint nn_membership_member_id not null
constraint fk_membership_members references members(member_id),
plan_id number(10) 
constraint nn_membership_plan_id not null
constraint fk_membership_plans references membership_plans(plan_id)
);     

create table payments(
payment_id number(10) generated as identity constraint pk_payments primary key,
membership_id number(10) 
constraint nn_payments_membership_id not null
constraint fk_payment_membership references membership(membership_id),
payment_date date constraint nn_payment_date not null,
amount number(8,2) CONSTRAINT nn_payments_amount NOT NULL constraint chk_payments_amount CHECK (amount >= 0),
payment_method varchar2(30),
payment_status varchar2(10) constraint chk_payment_status check (payment_status in ('SUCCESSFUL','PENDING', 'FAILED'))
);

create table trainers(
trainer_id number(10) generated as identity constraint pk_trainers primary key,
full_name varchar2(60) constraint nn_trainers_full_name not null,
specialization varchar2(30),
hire_date date
);

create table fitness_classes(
class_id number(10) generated as identity constraint pk_fitness_classes primary key,
trainer_id number(10) constraint fk_fitness_classes_trainers references trainers(trainer_id),
class_name varchar2(60) CONSTRAINT nn_fitness_classes_name NOT NULL,
capacity number(10) constraint chk_fitness_classes_capacity CHECK (capacity > 0) constraint nn_fitness_classes_capacity not null,
scheduled_at date default sysdate constraint nn_fitness_classes_schedule not null
);

create table class_booking(
member_id number(10)  constraint fk_class_booking_members references members(member_id),
class_id number(10)constraint fk_class_booking_classes references fitness_classes(class_id),
booking_date date constraint nn_class_booking_date not null,
attendance_status varchar2(120)
    CONSTRAINT chk_class_booking_attendance
    CHECK (attendance_status IN ('BOOKED', 'ATTENDED', 'ABSENT')),
constraint pk_class_booking primary key(member_id, class_id)
);


----------------------------------------------------------------------------------------
-- 1. MEMBERS
INSERT INTO members (full_name, email, phone, join_date, city)
VALUES ('Ahmed Hassan', 'ahmed@gmail.com', '01012345678', DATE '2026-01-10', 'Cairo');

INSERT INTO members (full_name, email, phone, join_date, city)
VALUES ('Sara Mohamed', 'sara@gmail.com', '01123456789', DATE '2026-02-15', 'Giza');

INSERT INTO members (full_name, email, phone, join_date, city)
VALUES ('Omar Ali', 'omar@gmail.com', NULL, DATE '2026-03-01', 'Cairo');

INSERT INTO members (full_name, email, phone, join_date, city)
VALUES ('Mariam Adel', NULL, '01234567890', DATE '2026-04-05', 'Alexandria');
        
INSERT INTO members (full_name, email, phone, join_date, city)
VALUES ('Youssef Samir', 'youssef@gmail.com', NULL, DATE '2026-05-20', 'Giza');

INSERT INTO members (full_name, join_date, city)
VALUES ('Nrmeen', DATE '2026-01-25', 'Cairo');
commit;

-- 2. MEMBERSHIP_PLANS
INSERT INTO membership_plans (plan_name, duration_months, price)
VALUES ('Monthly', 1, 500);

INSERT INTO membership_plans (plan_name, duration_months, price)
VALUES ('Quarterly', 3, 1350);

INSERT INTO membership_plans (plan_name, duration_months, price)
VALUES ('Annual', 12, 4500);

INSERT INTO membership_plans (plan_name, duration_months, price)
VALUES ('Premium', 6, 3000);

INSERT INTO membership_plans (plan_name, duration_months, price)
VALUES ('Student Plan', 2, 800);

-- 3. MEMBERSHIP
-- Ahmed: two memberships over time
INSERT INTO membership(start_date, end_date, membership_status, member_id, plan_id)
 VALUES (DATE '2026-01-10', DATE '2026-02-10', 'Expired', 1, 1);

INSERT INTO membership (start_date, end_date, membership_status, member_id, plan_id)
 VALUES (DATE '2026-03-01', DATE '2027-03-01', 'Active', 1, 3);
-- Sara: active membership
INSERT INTO membership(start_date, end_date, membership_status, member_id, plan_id)
VALUES (DATE '2026-02-15', DATE '2026-05-15', 'Active', 2, 2);
 
 -- Omar: pending membership
INSERT INTO membership  (start_date, end_date, membership_status, member_id, plan_id)
VALUES  (DATE '2026-06-01', DATE '2026-12-01', 'Pending', 3, 4);

-- Mariam: expired membership
INSERT INTO membership(start_date, end_date, membership_status, member_id, plan_id)
VALUES (DATE '2025-01-01', DATE '2025-04-01', 'Expired', 4, 2);

-- 4. PAYMENTS
-- Membership 1: multiple successful payments
INSERT INTO payments(membership_id, payment_date, amount, payment_method, payment_status)
VALUES (1, DATE '2026-01-10', 500, 'Cash', 'SUCCESSFUL');

INSERT INTO payments(membership_id, payment_date, amount, payment_method, payment_status)
VALUES (1, DATE '2026-01-20', 200, 'Card', 'SUCCESSFUL');

-- Membership 2: successful payment
INSERT INTO payments  (membership_id, payment_date, amount, payment_method, payment_status)
VALUES (2, DATE '2026-03-01', 4500, 'Card', 'SUCCESSFUL');

-- Membership 3: pending payment
INSERT INTO payments(membership_id, payment_date, amount, payment_method, payment_status)
VALUES (3, DATE '2026-02-15', 1350, 'Cash', 'PENDING');

-- Membership 5: failed payment
INSERT INTO payments (membership_id, payment_date, amount, payment_method, payment_status)
VALUES(5, DATE '2025-01-01', 1350, 'Online', 'FAILED');

-- 5. TRAINERS
INSERT INTO trainers (full_name, specialization, hire_date)
VALUES ('Khaled Ibrahim', 'Strength Training', DATE '2024-01-15');

INSERT INTO trainers (full_name, specialization, hire_date)
VALUES ('Nourhan Mostafa', 'Yoga', DATE '2023-06-01');

INSERT INTO trainers (full_name, specialization, hire_date)
VALUES ('Mahmoud Tarek', 'Cardio', DATE '2025-02-10');

INSERT INTO trainers (full_name, specialization, hire_date)
VALUES ('Dina Ashraf', 'Pilates', DATE '2025-08-20');

-- 6. FITNESS_CLASSES
INSERT INTO fitness_classes(trainer_id, class_name, capacity, scheduled_at)
VALUES(1, 'Strength Basics', 20, DATE '2026-10-20');

INSERT INTO fitness_classes(trainer_id, class_name, capacity, scheduled_at)
VALUES (2, 'Morning Yoga', 15, DATE '2026-10-21');

INSERT INTO fitness_classes(trainer_id, class_name, capacity, scheduled_at)
VALUES(1, 'Advanced Strength', 12, DATE '2026-10-22');

INSERT INTO fitness_classes(trainer_id, class_name, capacity, scheduled_at)
VALUES(NULL, 'Open Gym Session', 25, DATE '2026-10-23');

INSERT INTO fitness_classes(trainer_id, class_name, capacity, scheduled_at)
VALUES (3, 'Cardio Blast', 18, DATE '2026-10-24');

-- 7. CLASS_BOOKING
INSERT INTO class_booking(member_id, class_id, booking_date, attendance_status)
VALUES(1, 1, DATE '2026-10-15', 'ATTENDED');

INSERT INTO class_booking(member_id, class_id, booking_date, attendance_status)
VALUES(2, 1, DATE '2026-10-16', 'BOOKED');

INSERT INTO class_booking(member_id, class_id, booking_date, attendance_status)
VALUES(3, 2, DATE '2026-10-16', 'ATTENDED');

INSERT INTO class_booking(member_id, class_id, booking_date, attendance_status)
VALUES (4, 3, DATE '2026-10-17', 'ABSENT');

INSERT INTO class_booking(member_id, class_id, booking_date, attendance_status)
VALUES(1, 2, DATE '2026-10-17', 'BOOKED');

COMMIT;

----------------------------------------------------------------------------------------------------------------------------

-- 1
select msh.membership_id, m.full_name, mp.plan_name,msh.start_date, msh.membership_status
from membership msh join members m on msh.member_id = m.member_id
join membership_plans mp on msh.plan_id = mp.plan_id;

-- 2
select m.member_id, m.full_name, msh.membership_id, msh.start_date, msh.membership_status
from members m left join membership msh on m.member_id = msh.member_id;

-- 3 
select fc.class_id, fc.class_name, fc.scheduled_at, cb.booking_date, cb.attendance_status
from class_booking cb right join fitness_classes fc on cb.class_id=fc.class_id;

-- 4 
select t.trainer_id, t.full_name, t.specialization, t.hire_date, fc.class_id, fc.class_name
from trainers t left join fitness_classes fc on t.trainer_id = fc.trainer_id;
    
-- 5

select p.plan_name, count(msh.membership_id)as "Number of memberships", avg(p.price)as "Avg plan price"
from membership_plans p join membership msh on p.plan_id = msh.plan_id
group by p.plan_id, p.plan_name
order by avg(p.price) desc;

-- 6
select m.full_name, count(cb.member_id) as "Total number of bookings"
from members m left join class_booking cb on m.member_id = cb.member_id
group by m.member_id, m.full_name
order by count(cb.member_id) desc, m.full_name;

-- 7
select mp.plan_name, sum(p.amount) as "Total revenue" 
from membership_plans mp join membership msh on mp.plan_id=msh.plan_id 
join payments p on p.membership_id = msh.membership_id
where p.payment_status = 'SUCCESSFUL'
group by mp.plan_id, mp.plan_name
order by sum(p.amount) desc;

-- 8
select fc.class_id, fc.class_name, count(cb.class_id) as "Number of bookings"
from fitness_classes fc left join class_booking cb on fc.class_id = cb.class_id
group by fc.class_id, fc.class_name
order by count(cb.class_id) desc;

-- 9
select membership_id, 
      case  membership_status
         when 'Active' then 'Active Membership'
         when 'Expired' then 'Expired Membership'
         when 'Pending' then 'Pending Membership'
      end as "status label" 
from membership
order by membership_id;


-- 10
select full_name, coalesce(phone,email,'No contact details') as "Contact"
from members;

-- 11
select msh.membership_id, NVL(sum(p.amount),0) as "Total amount"
from membership msh left join payments p on msh.membership_id = p.membership_id
group by msh.membership_id;

-- 12
select t.full_name, count(fc.class_id) as "Number of assigned classes" 
from trainers t left join fitness_classes fc on t.trainer_id = fc.trainer_id
group by t.trainer_id, t.full_name
order by "Number of assigned classes" desc;

-- 13
select payment_id, membership_id, payment_method, amount, payment_date, 
    case payment_status
       when 'SUCCESSFUL' then 'Completed'
       when 'PENDING' then 'Pending'
       when 'FAILED' then 'Not completed'
    end as "payment status"
from payments
order by payment_date desc;

-- 14
select payment_method, sum(amount) as "Total amount",avg(amount) "Avg amount", 
min(amount) as "Min amount", max(amount) as "Max amount", count(*) as "Number of payments"
from payments
where payment_method is not null
group by payment_method; 

-- 15
select m.full_name, count(p.payment_id) as "Number of successful payments", 
     sum(p.amount) as "Total amount"
from members m join membership msh on m.member_id = msh.member_id
join payments p on p.membership_id= msh.membership_id
where p.payment_status = 'SUCCESSFUL'
group by m.member_id, m.full_name
having count(p.payment_id)>= 2
order by sum(p.amount) desc;