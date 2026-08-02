import '../domain/models.dart';
import 'workspace_view_model.dart';

class ProjectedTaskSection {
  const ProjectedTaskSection({
    required this.list,
    required this.status,
    required this.tasks,
  });

  final TaskList list;
  final TaskStatus status;
  final List<Task> tasks;
}

ProjectedTaskSection? selectedTaskSection(WorkspaceState state) {
  final list = state.selectedTaskList;
  final selected = state.selectedTask;
  if (list == null || selected == null) return null;
  final rootStatus = taskRoot(list, selected).status;
  final status = switch (rootStatus) {
    TaskStatus.doing => TaskStatus.pending,
    _ => rootStatus,
  };
  return ProjectedTaskSection(
    list: list,
    status: status,
    tasks: [
      for (final task in list.tasks)
        if (switch (taskRoot(list, task).status) {
              TaskStatus.doing => TaskStatus.pending,
              final rootStatus => rootStatus,
            } ==
            status)
          task,
    ],
  );
}

String sectionAsIndentedText(ProjectedTaskSection section) {
  final minimumDepth = section.tasks
      .map((task) => taskDepth(section.list, task))
      .fold<int>(3, (minimum, depth) => depth < minimum ? depth : minimum);
  return section.tasks
      .map((task) {
        final tabs = '\t' * (taskDepth(section.list, task) - minimumDepth);
        final tags = task.tags.isEmpty
            ? ''
            : ' ${task.tags.map((tag) => tag.glyph).join()}';
        return '$tabs${task.title}$tags';
      })
      .join('\n');
}

String selectedTasksAsIndentedText(TaskList list, Iterable<Task> tasks) => tasks
    .map((task) {
      final tags = task.tags.isEmpty
          ? ''
          : ' ${task.tags.map((tag) => tag.glyph).join()}';
      return '${'\t' * taskDepth(list, task)}${task.title}$tags';
    })
    .join('\n');
