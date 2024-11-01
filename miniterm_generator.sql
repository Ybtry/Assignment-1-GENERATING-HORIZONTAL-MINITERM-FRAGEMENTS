
CREATE TABLE predicates (
    id NUMBER PRIMARY KEY,
    expression VARCHAR2(500)
);


INSERT INTO predicates (id, expression) VALUES (1, 'e.empno=10 OR e.empno=20 OR e.empno=30');
INSERT INTO predicates (id, expression) VALUES (2, 'd.deptno IN (10, 20, 30)');
INSERT INTO predicates (id, expression) VALUES (3, 'e.ename=''KING'' OR d.deptno=40');
INSERT INTO predicates (id, expression) VALUES (4, 'd.deptno=50 OR d.dname=''ACCOUNTING''');


CREATE OR REPLACE PACKAGE miniterm_pkg IS
    TYPE predicate_list IS TABLE OF VARCHAR2(500);
    
    PROCEDURE generate_miniterms(predicates IN predicate_list);
END miniterm_pkg;
/

CREATE OR REPLACE PACKAGE BODY miniterm_pkg IS
    PROCEDURE generate_miniterms(predicates IN predicate_list) IS
        v_predicate_count NUMBER := predicates.COUNT;
        v_combinations NUMBER := POWER(2, v_predicate_count);
        v_miniterm VARCHAR2(4000); 
    BEGIN
        FOR i IN 0 .. v_combinations - 1 LOOP
            v_miniterm := '';
            FOR j IN 1 .. v_predicate_count LOOP
                IF BITAND(i, POWER(2, j - 1)) > 0 THEN
                    v_miniterm := v_miniterm || predicates(j) || ' = TRUE, ';
                ELSE
                    v_miniterm := v_miniterm || predicates(j) || ' = FALSE, ';
                END IF;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('Miniterm: ' || RTRIM(v_miniterm, ', '));
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END generate_miniterms;
END miniterm_pkg;
/

DECLARE
    preds miniterm_pkg.predicate_list := miniterm_pkg.predicate_list(
        'e.empno=10 OR e.empno=20 OR e.empno=30',
        'd.deptno IN (10, 20, 30)',
        'e.ename=''KING'' OR d.deptno=40',
        'd.deptno=50 OR d.dname=''ACCOUNTING'''
    );
BEGIN
    miniterm_pkg.generate_miniterms(preds);
END;
/
