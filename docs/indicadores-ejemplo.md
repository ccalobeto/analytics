# Ejemplo de Indicadores

Buenísimo, este KPI suele ser **el más mal entendido**, así que vamos con un **ejemplo muy concreto, paso a paso**, como para explicarlo en comité sin PowerPoint 😄.

---

## Contenido

## Pipeline ponderado por margen

Mide **Cuánto EBITDA potencial hay en el pipeline comercial**

---

### Paso 1️⃣ – Pipeline tradicional (lo que hoy suele verse)

Supongamos que Ventas tiene estas oportunidades abiertas:

| Cliente | Producto  | Monto venta (S/) | Prob. cierre |
| ------- | --------- | ---------------- | ------------ |
| A       | Cierres   | 100,000          | 60%          |
| B       | Elásticos | 80,000           | 40%          |
| C       | Etiquetas | 50,000           | 80%          |

#### Pipeline tradicional ponderado

```sh
Pipeline = Σ (Monto × probabilidad)
```

Cálculo:

* A: 100,000 × 0.6 = 60,000
* B: 80,000 × 0.4 = 32,000
* C: 50,000 × 0.8 = 40,000

👉 **Pipeline tradicional = S/ 132,000**

⚠️ Problema: **no sabemos si deja plata**.

---

### Paso 2️⃣ – Agregamos margen esperado (clave)

Ahora incorporamos el **margen bruto esperado** por oportunidad:

| Cliente | Monto (S/) | Prob. | Margen % |
| ------- | ---------- | ----- | -------- |
| A       | 100,000    | 60%   | 25%      |
| B       | 80,000     | 40%   | 12%      |
| C       | 50,000     | 80%   | 35%      |

---

### Paso 3️⃣ – Calculamos EBITDA potencial por oportunidad

Fórmula:

```sh
Pipeline EBITDA = Monto × margen × probabilidad
```

### Cálculo

* A: 100,000 × 25% × 60% = **15,000**
* B: 80,000 × 12% × 40% = **3,840**
* C: 50,000 × 35% × 80% = **14,000**

👉 **Pipeline ponderado por margen = 15,000 + 3,840 + 14,000 = S/ 32,840**

---

### 🧠 Interpretación gerencial (muy potente)

* Cliente B parece atractivo por monto,
  👉 pero aporta **solo 12% del EBITDA potencial**
* Cliente C es pequeño,
  👉 pero casi iguala el EBITDA del cliente A

---

### Variante avanzada (opcional)

Agregar un **factor de riesgo operativo**:

```sh
Pipeline EBITDA ajustado =
Monto × margen × probabilidad × factor operativo
```

Ejemplo:

* Cliente urgente, lotes pequeños → factor 0.8
* Cliente estable → factor 1.0

---

#### Conclusión

> “Tenemos S/ 132 mil en pipeline comercial,
> pero solo **S/ 32.8 mil de EBITDA potencial real**.”

---
