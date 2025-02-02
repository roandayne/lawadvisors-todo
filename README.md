Here’s a simple **README** for your task management API with position editing restrictions:

---

# **Task Management API**

## **Overview**
This API allows users to manage tasks, including creating, updating, retrieving, and deleting tasks. However, **editing the task position (`sort_order`) is not allowed**.

---

## **Endpoints**
Postman collection: https://drive.google.com/file/d/1s6Dc3OYy4_6bwPTnG_C1llIObVaX6DEK/view?usp=sharing

### **1. Get All Tasks**
**GET** `/api/tasks`  
Retrieves a list of all tasks.

### **2. Get a Single Task**
**GET** `/api/tasks/:id`  
Retrieves details of a specific task.

### **3. Create a New Task**
**POST** `/api/tasks`  
Creates a new task.  

#### **Request Body (JSON)**
```json
{
  "title": "New Todo",
  "description": "A new todo item",
  "status": "doing"
}
```

### **4. Update an Existing Task**
**PATCH / PUT** `/api/tasks/:id`  
Updates an existing task **(except for `position`)**.  

#### **Request Body (JSON)**
```json
{
    "title": "Editted Task 1"
    "description": "Editted Task 1 description"
}
```
🚨 **Editing `position` is not allowed**. If attempted, the API returns:  
```json
{
  "error": "Editing position is not allowed."
}
```

### **5. Delete a Task**
**DELETE** `/tasks/:id`  
Removes a task from the system.

### **6. Move a Task**
**POST** `/api/tasks/:id/move`  
Moves a task. 

#### **Request Body (JSON)**
Content-type: `application/x-www-form-urlencoded`
```
prev_task_id
next_task_id
```
🚨 **Only one of `prev_task_id` or `next_task_id` is required**.  

---

## **Setup Instructions**
### **1. Clone the Repository**
```sh
git clone https://github.com/roandayne/lawadvisors-todo.git
cd lawadvisors-todo
```

### **2. Install Dependencies**
```sh
bundle install
```

### **3. Run Migrations**
```sh
rails db:migrate
```

### **4. Start the Server**
```sh
rails server
```
API will be accessible at: **`http://localhost:3000](http://127.0.0.1:3000`**

