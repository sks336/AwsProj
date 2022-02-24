CREATE TABLE dbzuser.customer (
  id NUMBER(9) NOT NULL PRIMARY KEY,
  first_name VARCHAR2(255) NOT NULL,
  last_name VARCHAR2(255) NOT NULL,
  email VARCHAR2(255) NOT NULL UNIQUE
);

insert into dbzuser.customer(id, first_name, last_name, email) values(0, 'f-0', 'l-0', 'e-0')
;

ALTER TABLE dbzuser.customer ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS
;

-- ########################################################################################

--BEGIN
--FOR counter IN 1..10000 LOOP
--        INSERT INTO dbzuser.customer (id, first_name, last_name, email)
--            VALUES (counter,'f-' || counter,'l-' || counter, 'e-' || counter);
--
--END LOOP;
--COMMIT;
--END;

-- ########################################################################################