# CRM Backend

API Node.js/Express para el MVP CRM SENA.

## Requisitos

- Node.js
- MySQL local

## Configuración

1. Ajusta `.env` si tu usuario o contraseña de MySQL no son `root` sin contraseña.
   Si MySQL pide contraseña, agrega `DB_PASSWORD=tu_password`.
2. Crea la base de datos y tablas:

```bash
pnpm db:schema
```

3. Carga datos iniciales:

```bash
pnpm db:seed
```

Usuario demo:

- Email: `admin@crm.com`
- Contraseña: `admin123`

## Ejecución

```bash
pnpm start
```

La API queda disponible en `http://localhost:3000/api`.
