-- === TASKMANAGER DATABASE ===
CREATE DATABASE TaskManager;

--ELIMINAR TABLAS SI EXISTEN (Con cascade se eliminan las tablas dependientes[foráneas])
DROP TABLE IF EXISTS task_assignees CASCADE;
DROP TABLE IF EXISTS project_members CASCADE;
DROP TABLE IF EXISTS tasks CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS users CASCADE;

--Zona de enums
DROP TYPE IF EXISTS user_role CASCADE;
DROP TYPE IF EXISTS task_status CASCADE;
DROP TYPE IF EXISTS task_priority CASCADE;

CREATE TYPE user_role AS ENUM('ADMIN','USER');
CREATE TYPE task_status AS ENUM('TODO','IN_PROGRESS','DONE');
CREATE TYPE task_priority AS ENUM('LOW','MEDIUM','HIGH');

--TABLA USERS
CREATE TABLE users(
	id				BIGSERIAL PRIMARY KEY,
	name			VARCHAR(100)	NOT NULL,
	email			VARCHAR(150)	NOT NULL,
	password		VARCHAR(255)	NOT NULL,
	role			user_role		NOT NULL DEFAULT 'USER',
	active			BOOLEAN			NOT NULL DEFAULT TRUE,
	created_at		TIMESTAMP		NOT NULL DEFAULT NOW(),
	updated_at		TIMESTAMP		NOT NULL DEFAULT NOW()
);

--TABLA PROJECTS
CREATE TABLE projects(
	id 				BIGSERIAL PRIMARY KEY,
	name 			VARCHAR(150)	NOT NULL,
	description		TEXT,
	owner_id		BIGINT			NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	created_at		TIMESTAMP 		NOT NULL DEFAULT NOW(),
	updated_at 		TIMESTAMP		NOT NULL DEFAULT NOW()
);

--TABLA PROJECT MEMBERS(Relacion muchos a muchos entre users y projects)
CREATE TABLE project_members(
	project_id		BIGINT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
	user_id			BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	PRIMARY KEY (project_id,user_id)
);

--TABLA TASKS
CREATE TABLE tasks(
	id				BIGSERIAL PRIMARY KEY,
	title 			VARCHAR(200)	NOT NULL,
	description 	TEXT,
	status			task_status		NOT NULL DEFAULT 'TODO',
	priority		task_priority	NOT NULL DEFAULT 'MEDIUM',
	due_date		DATE,
	project_id		BIGINT NOT NULL	REFERENCES projects(id) ON DELETE CASCADE,
	created_by 		BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	created_at		TIMESTAMP		NOT NULL DEFAULT NOW(),
	updated_at		TIMESTAMP		NOT NULL DEFAULT NOW()
);

--Tabla task asigness (Relacion uno a muchos entre tareas a usuarios [Un usuario puede tener muchas tareas])
CREATE TABLE task_assignees(
	task_id			BIGINT NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
	user_id			BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	PRIMARY KEY(task_id,user_id)
);

--Indices para mejorar rendimiento
CREATE INDEX idx_projects_owner			ON projects(owner_id);
CREATE INDEX idx_tasks_project			ON tasks(project_id);
CREATE INDEX idx_tasks_status			ON tasks(status);
CREATE INDEX idx_tasks_created_by 		ON tasks(created_by);


--DATOS DE PRUEBA--
-- Usuarios (password = "password123" hasheado con BCrypt)
INSERT INTO users (name, email, password, role) VALUES
('Admin User',  'admin@test.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', 'ADMIN'),
('Juan Pérez',  'juan@test.com',  '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', 'USER'),
('María López', 'maria@test.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', 'USER');

-- Proyectos
INSERT INTO projects (name, description, owner_id) VALUES
('Website Redesign',   'Rediseño completo del sitio web corporativo', 1),
('App Móvil',          'Desarrollo de app móvil para clientes',        2),
('API Integración',    'Integración con servicios externos',            1);

-- Miembros de proyectos
INSERT INTO project_members (project_id, user_id) VALUES
(1, 1), (1, 2),
(2, 2), (2, 3),
(3, 1), (3, 3);

-- Tareas
INSERT INTO tasks (title, description, status, priority, due_date, project_id, created_by) VALUES
('Diseñar mockups',         'Crear wireframes en Figma',             'DONE',        'HIGH',   '2024-02-10', 1, 1),
('Implementar navbar',      'Componente de navegación responsive',   'IN_PROGRESS', 'HIGH',   '2024-02-20', 1, 2),
('Configurar CI/CD',        'Pipeline en GitHub Actions',            'TODO',        'MEDIUM', '2024-03-01', 1, 1),
('Login pantalla',          'Pantalla de autenticación',             'IN_PROGRESS', 'HIGH',   '2024-02-15', 2, 2),
('Push notifications',      'Integrar Firebase Cloud Messaging',     'TODO',        'LOW',    '2024-03-10', 2, 3),
('Conectar con Stripe',     'Integración de pagos',                  'TODO',        'HIGH',   '2024-02-28', 3, 1);

-- Asignaciones de tareas
INSERT INTO task_assignees (task_id, user_id) VALUES
(1, 1), (1, 2),
(2, 2),
(3, 1),
(4, 2), (4, 3),
(5, 3),
(6, 1);

