import 'package:task_management_app/features/Task_management/domain/entities/task.dart';

class Failure {
  final String errMsg;
  const Failure(this.errMsg);
}

final class OfflineFailure extends Failure {
  const OfflineFailure(super.errMsg);
}

final class EmptyCacheFailure extends Failure {
  const EmptyCacheFailure(super.errMsg);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.errMsg);
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.errMsg);
}

final class EndOfFileFailure extends Failure {
  final List<Task> tasksList;
  const EndOfFileFailure(super.errMsg, {required this.tasksList});
}
