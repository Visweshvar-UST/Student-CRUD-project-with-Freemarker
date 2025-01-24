<!DOCTYPE html>
<html>
<head>
    <title>Student Management</title>
</head>
<body>
    <div class="container mt-5">
        <!-- Create New Student Form -->
        <h3>Create New Student</h3>
        <form action="/api/v1/student-view" method="post">
            <div class="mb-3">
                <label for="name" class="form-label">Name</label>
                <input type="text" class="form-control" id="name" name="name" required>
            </div>
            <div class="mb-3">
                <label for="age" class="form-label">Age</label>
                <input type="number" class="form-control" id="age" name="age" required>
            </div>
            <button type="submit" class="btn btn-primary">Submit</button>
        </form>

        <!-- Student List -->
        <h1 class="text-center mt-4">Students</h1>
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Age</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <#list students as student>
                        <tr>
                            <td>${student.id}</td>
                            <td>${student.name}</td>
                            <td>${student.age}</td>
                            <td>
                                <button type="button" class="btn btn-warning btn-sm edit-btn"
                                        data-id="${student.id}"
                                        data-name="${student.name}"
                                        data-age="${student.age}">
                                    Edit
                                </button>
                                <button type="button" class="btn btn-danger btn-sm delete-btn" data-id="${student.id}">
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </#list>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Edit Student Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="editStudentForm">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModalLabel">Edit Student</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="edit-id" name="id">
                        <div class="mb-3">
                            <label for="edit-name" class="form-label">Name</label>
                            <input type="text" class="form-control" id="edit-name" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-age" class="form-label">Age</label>
                            <input type="number" class="form-control" id="edit-age" name="age" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
    $(document).ready(function () {
        $('.edit-btn').on('click', function () {
            const id = $(this).data('id');
            const name = $(this).data('name');
            const age = $(this).data('age');
            
            console.log("Edit Button Clicked!");
            console.log("ID: " + id);
            console.log("Name: " + name);
            console.log("Age: " + age);
            
            $('#edit-id').val(id);
            $('#edit-name').val(name);
            $('#edit-age').val(age);
            
            $('#editModal').modal('show');
        });

        $('#editStudentForm').on('submit', function (e) {
            e.preventDefault();
            const id = $('#edit-id').val();
            const name = $('#edit-name').val();
            const age = $('#edit-age').val();
            
            const dataToSend = `name=${encodeURIComponent(name)}&age=${encodeURIComponent(age)}`;
            console.log("Sending data: ", dataToSend);
            
            $.ajax({
                url: `/api/v1/students/${id}?${dataToSend}`,
                method: 'PUT',
                contentType: 'application/x-www-form-urlencoded',  // Use the correct content type for query params
                success: function () {
                    console.log("Student updated successfully!");
                    alert('Student updated successfully!');
                    location.reload();
                },
                error: function (xhr, status, error) {
                    console.error("Error updating student:", xhr.responseText);
                    console.error("Status: " + status);
                    console.error("Error: " + error);
                    alert('Failed to update student.');
                }
            });
        });

        $('.delete-btn').on('click', function () {
            const id = $(this).data('id');
            
            console.log("Delete Button Clicked for ID: " + id);
            
            if (confirm('Are you sure you want to delete this student?')) {
                $.ajax({
                    url: `/api/v1/students/${id}`,
                    method: 'DELETE',
                    success: function () {
                        console.log("Student deleted successfully!");
                        alert('Student deleted successfully!');
                        location.reload();
                    },
                    error: function (xhr, status, error) {
                        console.error("Error deleting student:", xhr.responseText);
                        console.error("Status: " + status);
                        console.error("Error: " + error);
                        alert('Failed to delete student.');
                    }
                });
            }
        });
    });
    </script>
</body>
</html>
