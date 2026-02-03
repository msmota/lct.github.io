CREATE OR REPLACE PACKAGE pck_calculadora AS

    FUNCTION soma(a NUMBER, b NUMBER) RETURN NUMBER;
    FUNCTION subtracao(a NUMBER, b NUMBER) RETURN NUMBER;
    FUNCTION multiplicacao(a NUMBER, b NUMBER) RETURN NUMBER;
    FUNCTION divisao(a NUMBER, b NUMBER) RETURN NUMBER;
    FUNCTION potencia(a NUMBER, b NUMBER) RETURN NUMBER;

    -- Função calculadora geral
    FUNCTION calcular(p_op VARCHAR2, a NUMBER, b NUMBER) RETURN NUMBER;

END pck_calculadora;
/
CREATE OR REPLACE PACKAGE BODY pck_calculadora AS

---------------------------------------------------
-- FUNÇÃO BASE (ÚNICA OPERAÇÃO REAL)
---------------------------------------------------
FUNCTION f_add(a NUMBER, b NUMBER) RETURN NUMBER IS
BEGIN
    RETURN a + b;
END;

---------------------------------------------------
-- SUBTRAÇÃO via soma de -1
---------------------------------------------------
FUNCTION f_sub(a NUMBER, b NUMBER) RETURN NUMBER IS
    resultado NUMBER := a;
    contador NUMBER := 0;
BEGIN
    WHILE contador < b LOOP
        resultado := resultado + (-1);
        contador := contador + 1;
    END LOOP;

    RETURN resultado;
END;

---------------------------------------------------
-- MULTIPLICAÇÃO via soma repetida
---------------------------------------------------
FUNCTION f_mul(a NUMBER, b NUMBER) RETURN NUMBER IS
    resultado NUMBER := 0;
    contador NUMBER := 0;
BEGIN
    WHILE contador < b LOOP
        resultado := resultado + a;
        contador := contador + 1;
    END LOOP;

    RETURN resultado;
END;

---------------------------------------------------
-- DIVISÃO via contagem
---------------------------------------------------
FUNCTION f_div(a NUMBER, b NUMBER) RETURN NUMBER IS
    quociente NUMBER := 0;
    acumulado NUMBER := 0;
BEGIN
    IF b = 0 THEN
        RETURN NULL;
    END IF;

    WHILE (acumulado + b) <= a LOOP
        acumulado := acumulado + b;
        quociente := quociente + 1;
    END LOOP;

    RETURN quociente;
END;

---------------------------------------------------
-- POTÊNCIA via multiplicação repetida
---------------------------------------------------
FUNCTION f_pow(a NUMBER, b NUMBER) RETURN NUMBER IS
    resultado NUMBER := 1;
    contador NUMBER := 0;
BEGIN
    WHILE contador < b LOOP
        resultado := f_mul(resultado, a);
        contador := contador + 1;
    END LOOP;

    RETURN resultado;
END;

---------------------------------------------------
-- FUNÇÕES PÚBLICAS (CHAMAM AS INTERNAS)
---------------------------------------------------
FUNCTION soma(a NUMBER, b NUMBER) RETURN NUMBER IS
BEGIN
    RETURN f_add(a,b);
END;

FUNCTION subtracao(a NUMBER, b NUMBER) RETURN NUMBER IS
BEGIN
    RETURN f_sub(a,b);
END;

FUNCTION multiplicacao(a NUMBER, b NUMBER) RETURN NUMBER IS
BEGIN
    RETURN f_mul(a,b);
END;

FUNCTION divisao(a NUMBER, b NUMBER) RETURN NUMBER IS
BEGIN
    RETURN f_div(a,b);
END;

FUNCTION potencia(a NUMBER, b NUMBER) RETURN NUMBER IS
BEGIN
    RETURN f_pow(a,b);
END;

---------------------------------------------------
-- CALCULADORA GENÉRICA
---------------------------------------------------
FUNCTION calcular(p_op VARCHAR2, a NUMBER, b NUMBER) 
RETURN NUMBER IS
BEGIN
    CASE p_op
        WHEN '+' THEN RETURN soma(a,b);
        WHEN '-' THEN RETURN subtracao(a,b);
        WHEN '*' THEN RETURN multiplicacao(a,b);
        WHEN '/' THEN RETURN divisao(a,b);
        WHEN '^' THEN RETURN potencia(a,b);
        ELSE RETURN NULL;
    END CASE;
END;

END pck_calculadora;
/
