------------------------------------------------------TO UPDATE FROM UI SELECT ROWID TOO
SELECT a.rowid, a.* FROM table_name a

------------------------------------------------------CREATE COPY OF TABLE WITHOUT ANY ELEMENTS
CREATE TABLE new_table AS
SELECT * FROM table_name WHERE 1=0

------------------------------------------------------DELETE FIRST CHARACTER FROM ELEMENT(CAN BE DONE WITH MANY ELEMENTS)
------------------------------------------------------user_id HAVE 5 CHARACTERS -> -4
update table_name set user_id = substr(user_id, -4) where user_id = '12345'

------------------------------------------------------SIMPLE SUBQUERY EXAMPLE
SELECT * FROM table1 WHERE user_id IN (SELECT user_id FROM table2)

------------------------------------------------------SIMPLE JOIN EXAMPLE(JOINING BY ID COLUMN)
SELECT a.*, b.* FROM table1 a
JOIN table2 b ON a.user_id = b.user_id
--WHERE 1 = 1

------------------------------------------------------SIMPLE CREATE, EXECUTE, DELETE PROCEDURE
CREATE OR REPLACE PROCEDURE my_procedure_name --IF HAVE ARGUMENTS ADD THEM IN ()
AS
var1 VARCHAR(32767);
BEGIN
var1 := 'procedure output';
dbms_output.put_line (var1);
END;

BEGIN
my_procedure_name;
END;

DROP PROCEDURE my_procedure_name;

------------------------------------------------------SIMPLE CURSOR EXAMPLE
DECLARE
CURSOR cursor_name IS (SELECT user_id FROM table_name);
var1 INT;

BEGIN
  OPEN cursor_name;
    LOOP
    EXIT WHEN cursor_name%NOTFOUND;
    FETCH cursor_name  INTO  var1;
    dbms_output.put_line (var1);
    END LOOP;
  CLOSE cursor_name;
END;

------------------------------------------------------CREATE AND USE DATABASE LINK AND USE
CREATE DATABASE LINK link_name
    CONNECT TO other_db_name
    IDENTIFIED BY "password"
    USING 'username';

SELECT * FROM other_db_table_name@link_name

------------------------------------------------------COUNT OF ALL ROWS IN EVERY MINUTE(IF TABLE HAVE CREATION_DATE ROW)
SELECT TO_CHAR(creation_date, 'HH24:MI') creation_time, COUNT(*)
FROM table_name
WHERE 1=1
AND creation_date >= to_date('29.01.2024 08:00:00','dd-mm-yyyy hh24:mi:ss')
AND creation_date <= to_date('29.01.2024 09:00:00','dd-mm-yyyy hh24:mi:ss')
GROUP BY TO_CHAR(creation_date, 'HH24:MI')
ORDER BY TO_CHAR(creation_date, 'HH24:MI')

------------------------------------------------------SEND MAIL BY SMTP(TESTED ON LOCAL NETWORK), SMTP MUST BE IN DATABASE SERVER
CREATE OR REPLACE PROCEDURE test_send_mail_y (p_to        IN VARCHAR2,
                                              p_from      IN VARCHAR2,
                                              p_message   IN VARCHAR2,
                                              p_smtp_host IN VARCHAR2,
                                              p_smtp_port IN NUMBER DEFAULT 25)
AS
  l_mail_conn   UTL_SMTP.connection;
  --v_replies      UTL_SMTP.replies;
  v_reply        UTL_SMTP.reply;
BEGIN
  l_mail_conn := UTL_SMTP.open_connection(p_smtp_host, p_smtp_port);

  v_reply := UTL_SMTP.helo(l_mail_conn, p_smtp_host);
  DBMS_OUTPUT.put_line('Reply: ' || v_reply.code || ' ' || v_reply.text);

  v_reply := UTL_SMTP.mail(l_mail_conn, p_from);
  DBMS_OUTPUT.put_line('Reply: ' || v_reply.code || ' ' || v_reply.text);

  v_reply := UTL_SMTP.rcpt(l_mail_conn, p_to);
  DBMS_OUTPUT.put_line('Reply: ' || v_reply.code || ' ' || v_reply.text);

  v_reply := UTL_SMTP.data(l_mail_conn, p_message || UTL_TCP.crlf || UTL_TCP.crlf);
  DBMS_OUTPUT.put_line('Reply: ' || v_reply.code || ' ' || v_reply.text);

  v_reply := UTL_SMTP.quit(l_mail_conn);
  DBMS_OUTPUT.put_line('Reply: ' || v_reply.code || ' ' || v_reply.text);

END;

--EXECUTE
BEGIN
test_send_mail_y( 
                p_to        => 'mail_address_to',
                p_from      => 'mail_address_from',
                p_message   => 'message text',
                p_smtp_host => 'localhost'
                --ADD PORT IF THATS NOT 25
                );
END;