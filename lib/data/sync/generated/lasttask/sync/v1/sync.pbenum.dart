// This is a generated file - do not edit.
//
// Generated from lasttask/sync/v1/sync.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TaskStatus extends $pb.ProtobufEnum {
  static const TaskStatus TASK_STATUS_UNSPECIFIED =
      TaskStatus._(0, _omitEnumNames ? '' : 'TASK_STATUS_UNSPECIFIED');
  static const TaskStatus TASK_STATUS_PENDING =
      TaskStatus._(1, _omitEnumNames ? '' : 'TASK_STATUS_PENDING');
  static const TaskStatus TASK_STATUS_DOING =
      TaskStatus._(2, _omitEnumNames ? '' : 'TASK_STATUS_DOING');
  static const TaskStatus TASK_STATUS_DONE =
      TaskStatus._(3, _omitEnumNames ? '' : 'TASK_STATUS_DONE');
  static const TaskStatus TASK_STATUS_ARCHIVED =
      TaskStatus._(4, _omitEnumNames ? '' : 'TASK_STATUS_ARCHIVED');

  static const $core.List<TaskStatus> values = <TaskStatus>[
    TASK_STATUS_UNSPECIFIED,
    TASK_STATUS_PENDING,
    TASK_STATUS_DOING,
    TASK_STATUS_DONE,
    TASK_STATUS_ARCHIVED,
  ];

  static final $core.List<TaskStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TaskStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaskStatus._(super.value, super.name);
}

class TaskTag extends $pb.ProtobufEnum {
  static const TaskTag TASK_TAG_UNSPECIFIED =
      TaskTag._(0, _omitEnumNames ? '' : 'TASK_TAG_UNSPECIFIED');
  static const TaskTag TASK_TAG_SPADE =
      TaskTag._(1, _omitEnumNames ? '' : 'TASK_TAG_SPADE');
  static const TaskTag TASK_TAG_HEART =
      TaskTag._(2, _omitEnumNames ? '' : 'TASK_TAG_HEART');
  static const TaskTag TASK_TAG_CLUB =
      TaskTag._(3, _omitEnumNames ? '' : 'TASK_TAG_CLUB');
  static const TaskTag TASK_TAG_DIAMOND =
      TaskTag._(4, _omitEnumNames ? '' : 'TASK_TAG_DIAMOND');

  static const $core.List<TaskTag> values = <TaskTag>[
    TASK_TAG_UNSPECIFIED,
    TASK_TAG_SPADE,
    TASK_TAG_HEART,
    TASK_TAG_CLUB,
    TASK_TAG_DIAMOND,
  ];

  static final $core.List<TaskTag?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TaskTag? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaskTag._(super.value, super.name);
}

class MutationResultStatus extends $pb.ProtobufEnum {
  static const MutationResultStatus MUTATION_RESULT_STATUS_UNSPECIFIED =
      MutationResultStatus._(
          0, _omitEnumNames ? '' : 'MUTATION_RESULT_STATUS_UNSPECIFIED');
  static const MutationResultStatus MUTATION_RESULT_STATUS_APPLIED =
      MutationResultStatus._(
          1, _omitEnumNames ? '' : 'MUTATION_RESULT_STATUS_APPLIED');
  static const MutationResultStatus MUTATION_RESULT_STATUS_ALREADY_APPLIED =
      MutationResultStatus._(
          2, _omitEnumNames ? '' : 'MUTATION_RESULT_STATUS_ALREADY_APPLIED');
  static const MutationResultStatus MUTATION_RESULT_STATUS_NO_OP =
      MutationResultStatus._(
          3, _omitEnumNames ? '' : 'MUTATION_RESULT_STATUS_NO_OP');
  static const MutationResultStatus MUTATION_RESULT_STATUS_REJECTED =
      MutationResultStatus._(
          4, _omitEnumNames ? '' : 'MUTATION_RESULT_STATUS_REJECTED');

  static const $core.List<MutationResultStatus> values = <MutationResultStatus>[
    MUTATION_RESULT_STATUS_UNSPECIFIED,
    MUTATION_RESULT_STATUS_APPLIED,
    MUTATION_RESULT_STATUS_ALREADY_APPLIED,
    MUTATION_RESULT_STATUS_NO_OP,
    MUTATION_RESULT_STATUS_REJECTED,
  ];

  static final $core.List<MutationResultStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static MutationResultStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MutationResultStatus._(super.value, super.name);
}

class StatusChangeReason extends $pb.ProtobufEnum {
  static const StatusChangeReason STATUS_CHANGE_REASON_UNSPECIFIED =
      StatusChangeReason._(
          0, _omitEnumNames ? '' : 'STATUS_CHANGE_REASON_UNSPECIFIED');
  static const StatusChangeReason STATUS_CHANGE_REASON_USER =
      StatusChangeReason._(
          1, _omitEnumNames ? '' : 'STATUS_CHANGE_REASON_USER');
  static const StatusChangeReason STATUS_CHANGE_REASON_DAILY_RESET =
      StatusChangeReason._(
          2, _omitEnumNames ? '' : 'STATUS_CHANGE_REASON_DAILY_RESET');
  static const StatusChangeReason STATUS_CHANGE_REASON_UNDO =
      StatusChangeReason._(
          3, _omitEnumNames ? '' : 'STATUS_CHANGE_REASON_UNDO');

  static const $core.List<StatusChangeReason> values = <StatusChangeReason>[
    STATUS_CHANGE_REASON_UNSPECIFIED,
    STATUS_CHANGE_REASON_USER,
    STATUS_CHANGE_REASON_DAILY_RESET,
    STATUS_CHANGE_REASON_UNDO,
  ];

  static final $core.List<StatusChangeReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static StatusChangeReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StatusChangeReason._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
