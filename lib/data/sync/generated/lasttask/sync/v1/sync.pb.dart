// This is a generated file - do not edit.
//
// Generated from lasttask/sync/v1/sync.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/field_mask.pb.dart' as $1;
import '../../../google/protobuf/timestamp.pb.dart' as $0;
import 'sync.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'sync.pbenum.dart';

class Task extends $pb.GeneratedMessage {
  factory Task({
    $core.String? id,
    $core.String? title,
    TaskStatus? status,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $0.Timestamp? completedAt,
    $core.bool? daily,
    $core.Iterable<TaskTag>? tags,
    $core.String? parentId,
    $core.Iterable<CompletionEvent>? completionEvents,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (completedAt != null) result.completedAt = completedAt;
    if (daily != null) result.daily = daily;
    if (tags != null) result.tags.addAll(tags);
    if (parentId != null) result.parentId = parentId;
    if (completionEvents != null)
      result.completionEvents.addAll(completionEvents);
    return result;
  }

  Task._();

  factory Task.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Task.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Task',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..e<TaskStatus>(3, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: TaskStatus.TASK_STATUS_UNSPECIFIED,
        valueOf: TaskStatus.valueOf,
        enumValues: TaskStatus.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(7, _omitFieldNames ? '' : 'daily')
    ..pc<TaskTag>(8, _omitFieldNames ? '' : 'tags', $pb.PbFieldType.KE,
        valueOf: TaskTag.valueOf,
        enumValues: TaskTag.values,
        defaultEnumValue: TaskTag.TASK_TAG_UNSPECIFIED)
    ..aOS(9, _omitFieldNames ? '' : 'parentId')
    ..pc<CompletionEvent>(
        10, _omitFieldNames ? '' : 'completionEvents', $pb.PbFieldType.PM,
        subBuilder: CompletionEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Task clone() => Task()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Task copyWith(void Function(Task) updates) =>
      super.copyWith((message) => updates(message as Task)) as Task;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Task create() => Task._();
  @$core.override
  Task createEmptyInstance() => create();
  static $pb.PbList<Task> createRepeated() => $pb.PbList<Task>();
  @$core.pragma('dart2js:noInline')
  static Task getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Task>(create);
  static Task? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  TaskStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(TaskStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get createdAt => $_getN(3);
  @$pb.TagNumber(4)
  set createdAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureCreatedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get updatedAt => $_getN(4);
  @$pb.TagNumber(5)
  set updatedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdatedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureUpdatedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get completedAt => $_getN(5);
  @$pb.TagNumber(6)
  set completedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCompletedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCompletedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureCompletedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get daily => $_getBF(6);
  @$pb.TagNumber(7)
  set daily($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDaily() => $_has(6);
  @$pb.TagNumber(7)
  void clearDaily() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<TaskTag> get tags => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get parentId => $_getSZ(8);
  @$pb.TagNumber(9)
  set parentId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasParentId() => $_has(8);
  @$pb.TagNumber(9)
  void clearParentId() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<CompletionEvent> get completionEvents => $_getList(9);
}

class CompletionEvent extends $pb.GeneratedMessage {
  factory CompletionEvent({
    $core.String? id,
    $0.Timestamp? occurredAt,
    $core.String? logicalDate,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (logicalDate != null) result.logicalDate = logicalDate;
    return result;
  }

  CompletionEvent._();

  factory CompletionEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompletionEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompletionEvent',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'logicalDate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompletionEvent clone() => CompletionEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompletionEvent copyWith(void Function(CompletionEvent) updates) =>
      super.copyWith((message) => updates(message as CompletionEvent))
          as CompletionEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompletionEvent create() => CompletionEvent._();
  @$core.override
  CompletionEvent createEmptyInstance() => create();
  static $pb.PbList<CompletionEvent> createRepeated() =>
      $pb.PbList<CompletionEvent>();
  @$core.pragma('dart2js:noInline')
  static CompletionEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompletionEvent>(create);
  static CompletionEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get occurredAt => $_getN(1);
  @$pb.TagNumber(2)
  set occurredAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOccurredAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearOccurredAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureOccurredAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get logicalDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set logicalDate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLogicalDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearLogicalDate() => $_clearField(3);
}

class TaskList extends $pb.GeneratedMessage {
  factory TaskList({
    $core.int? schemaVersion,
    $core.String? id,
    $core.String? name,
    $0.Timestamp? createdAt,
    $core.bool? habit,
    $core.bool? tutorial,
    $fixnum.Int64? version,
    $core.Iterable<Task>? tasks,
  }) {
    final result = create();
    if (schemaVersion != null) result.schemaVersion = schemaVersion;
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (createdAt != null) result.createdAt = createdAt;
    if (habit != null) result.habit = habit;
    if (tutorial != null) result.tutorial = tutorial;
    if (version != null) result.version = version;
    if (tasks != null) result.tasks.addAll(tasks);
    return result;
  }

  TaskList._();

  factory TaskList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TaskList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TaskList',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'schemaVersion', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(5, _omitFieldNames ? '' : 'habit')
    ..aOB(6, _omitFieldNames ? '' : 'tutorial')
    ..aInt64(7, _omitFieldNames ? '' : 'version')
    ..pc<Task>(8, _omitFieldNames ? '' : 'tasks', $pb.PbFieldType.PM,
        subBuilder: Task.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TaskList clone() => TaskList()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TaskList copyWith(void Function(TaskList) updates) =>
      super.copyWith((message) => updates(message as TaskList)) as TaskList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TaskList create() => TaskList._();
  @$core.override
  TaskList createEmptyInstance() => create();
  static $pb.PbList<TaskList> createRepeated() => $pb.PbList<TaskList>();
  @$core.pragma('dart2js:noInline')
  static TaskList getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TaskList>(create);
  static TaskList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get schemaVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set schemaVersion($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchemaVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchemaVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get createdAt => $_getN(3);
  @$pb.TagNumber(4)
  set createdAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureCreatedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get habit => $_getBF(4);
  @$pb.TagNumber(5)
  set habit($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHabit() => $_has(4);
  @$pb.TagNumber(5)
  void clearHabit() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get tutorial => $_getBF(5);
  @$pb.TagNumber(6)
  set tutorial($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTutorial() => $_has(5);
  @$pb.TagNumber(6)
  void clearTutorial() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get version => $_getI64(6);
  @$pb.TagNumber(7)
  set version($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearVersion() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<Task> get tasks => $_getList(7);
}

class ResourceVersion extends $pb.GeneratedMessage {
  factory ResourceVersion({
    $core.String? listId,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (version != null) result.version = version;
    return result;
  }

  ResourceVersion._();

  factory ResourceVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceVersion',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aInt64(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceVersion clone() => ResourceVersion()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceVersion copyWith(void Function(ResourceVersion) updates) =>
      super.copyWith((message) => updates(message as ResourceVersion))
          as ResourceVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceVersion create() => ResourceVersion._();
  @$core.override
  ResourceVersion createEmptyInstance() => create();
  static $pb.PbList<ResourceVersion> createRepeated() =>
      $pb.PbList<ResourceVersion>();
  @$core.pragma('dart2js:noInline')
  static ResourceVersion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceVersion>(create);
  static ResourceVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get version => $_getI64(1);
  @$pb.TagNumber(2)
  set version($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class CreateList extends $pb.GeneratedMessage {
  factory CreateList({
    $core.String? listId,
    $core.String? name,
    $0.Timestamp? createdAt,
    $core.bool? habit,
    $core.bool? tutorial,
    $core.String? afterListId,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (name != null) result.name = name;
    if (createdAt != null) result.createdAt = createdAt;
    if (habit != null) result.habit = habit;
    if (tutorial != null) result.tutorial = tutorial;
    if (afterListId != null) result.afterListId = afterListId;
    return result;
  }

  CreateList._();

  factory CreateList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateList',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(4, _omitFieldNames ? '' : 'habit')
    ..aOB(5, _omitFieldNames ? '' : 'tutorial')
    ..aOS(6, _omitFieldNames ? '' : 'afterListId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateList clone() => CreateList()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateList copyWith(void Function(CreateList) updates) =>
      super.copyWith((message) => updates(message as CreateList)) as CreateList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateList create() => CreateList._();
  @$core.override
  CreateList createEmptyInstance() => create();
  static $pb.PbList<CreateList> createRepeated() => $pb.PbList<CreateList>();
  @$core.pragma('dart2js:noInline')
  static CreateList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateList>(create);
  static CreateList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get createdAt => $_getN(2);
  @$pb.TagNumber(3)
  set createdAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureCreatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get habit => $_getBF(3);
  @$pb.TagNumber(4)
  set habit($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHabit() => $_has(3);
  @$pb.TagNumber(4)
  void clearHabit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get tutorial => $_getBF(4);
  @$pb.TagNumber(5)
  set tutorial($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTutorial() => $_has(4);
  @$pb.TagNumber(5)
  void clearTutorial() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get afterListId => $_getSZ(5);
  @$pb.TagNumber(6)
  set afterListId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAfterListId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAfterListId() => $_clearField(6);
}

class RenameList extends $pb.GeneratedMessage {
  factory RenameList({
    $core.String? listId,
    $core.String? name,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (name != null) result.name = name;
    return result;
  }

  RenameList._();

  factory RenameList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RenameList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenameList',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameList clone() => RenameList()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameList copyWith(void Function(RenameList) updates) =>
      super.copyWith((message) => updates(message as RenameList)) as RenameList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenameList create() => RenameList._();
  @$core.override
  RenameList createEmptyInstance() => create();
  static $pb.PbList<RenameList> createRepeated() => $pb.PbList<RenameList>();
  @$core.pragma('dart2js:noInline')
  static RenameList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RenameList>(create);
  static RenameList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class DeleteList extends $pb.GeneratedMessage {
  factory DeleteList({
    $core.String? listId,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    return result;
  }

  DeleteList._();

  factory DeleteList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteList',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteList clone() => DeleteList()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteList copyWith(void Function(DeleteList) updates) =>
      super.copyWith((message) => updates(message as DeleteList)) as DeleteList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteList create() => DeleteList._();
  @$core.override
  DeleteList createEmptyInstance() => create();
  static $pb.PbList<DeleteList> createRepeated() => $pb.PbList<DeleteList>();
  @$core.pragma('dart2js:noInline')
  static DeleteList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteList>(create);
  static DeleteList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);
}

class RestoreList extends $pb.GeneratedMessage {
  factory RestoreList({
    TaskList? list,
    $core.String? afterListId,
  }) {
    final result = create();
    if (list != null) result.list = list;
    if (afterListId != null) result.afterListId = afterListId;
    return result;
  }

  RestoreList._();

  factory RestoreList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestoreList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestoreList',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOM<TaskList>(1, _omitFieldNames ? '' : 'list',
        subBuilder: TaskList.create)
    ..aOS(2, _omitFieldNames ? '' : 'afterListId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreList clone() => RestoreList()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreList copyWith(void Function(RestoreList) updates) =>
      super.copyWith((message) => updates(message as RestoreList))
          as RestoreList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestoreList create() => RestoreList._();
  @$core.override
  RestoreList createEmptyInstance() => create();
  static $pb.PbList<RestoreList> createRepeated() => $pb.PbList<RestoreList>();
  @$core.pragma('dart2js:noInline')
  static RestoreList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestoreList>(create);
  static RestoreList? _defaultInstance;

  @$pb.TagNumber(1)
  TaskList get list => $_getN(0);
  @$pb.TagNumber(1)
  set list(TaskList value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasList() => $_has(0);
  @$pb.TagNumber(1)
  void clearList() => $_clearField(1);
  @$pb.TagNumber(1)
  TaskList ensureList() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get afterListId => $_getSZ(1);
  @$pb.TagNumber(2)
  set afterListId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfterListId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfterListId() => $_clearField(2);
}

class MoveList extends $pb.GeneratedMessage {
  factory MoveList({
    $core.String? listId,
    $core.String? afterListId,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (afterListId != null) result.afterListId = afterListId;
    return result;
  }

  MoveList._();

  factory MoveList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoveList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveList',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'afterListId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveList clone() => MoveList()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveList copyWith(void Function(MoveList) updates) =>
      super.copyWith((message) => updates(message as MoveList)) as MoveList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveList create() => MoveList._();
  @$core.override
  MoveList createEmptyInstance() => create();
  static $pb.PbList<MoveList> createRepeated() => $pb.PbList<MoveList>();
  @$core.pragma('dart2js:noInline')
  static MoveList getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoveList>(create);
  static MoveList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get afterListId => $_getSZ(1);
  @$pb.TagNumber(2)
  set afterListId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfterListId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfterListId() => $_clearField(2);
}

class CreateTask extends $pb.GeneratedMessage {
  factory CreateTask({
    $core.String? listId,
    Task? task,
    $core.String? afterTaskId,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (task != null) result.task = task;
    if (afterTaskId != null) result.afterTaskId = afterTaskId;
    return result;
  }

  CreateTask._();

  factory CreateTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTask',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOM<Task>(2, _omitFieldNames ? '' : 'task', subBuilder: Task.create)
    ..aOS(3, _omitFieldNames ? '' : 'afterTaskId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTask clone() => CreateTask()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTask copyWith(void Function(CreateTask) updates) =>
      super.copyWith((message) => updates(message as CreateTask)) as CreateTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTask create() => CreateTask._();
  @$core.override
  CreateTask createEmptyInstance() => create();
  static $pb.PbList<CreateTask> createRepeated() => $pb.PbList<CreateTask>();
  @$core.pragma('dart2js:noInline')
  static CreateTask getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTask>(create);
  static CreateTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  Task get task => $_getN(1);
  @$pb.TagNumber(2)
  set task(Task value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTask() => $_has(1);
  @$pb.TagNumber(2)
  void clearTask() => $_clearField(2);
  @$pb.TagNumber(2)
  Task ensureTask() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get afterTaskId => $_getSZ(2);
  @$pb.TagNumber(3)
  set afterTaskId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAfterTaskId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfterTaskId() => $_clearField(3);
}

class UpdateTask extends $pb.GeneratedMessage {
  factory UpdateTask({
    $core.String? listId,
    Task? task,
    $1.FieldMask? updateMask,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (task != null) result.task = task;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdateTask._();

  factory UpdateTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateTask',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOM<Task>(2, _omitFieldNames ? '' : 'task', subBuilder: Task.create)
    ..aOM<$1.FieldMask>(3, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $1.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTask clone() => UpdateTask()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateTask copyWith(void Function(UpdateTask) updates) =>
      super.copyWith((message) => updates(message as UpdateTask)) as UpdateTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateTask create() => UpdateTask._();
  @$core.override
  UpdateTask createEmptyInstance() => create();
  static $pb.PbList<UpdateTask> createRepeated() => $pb.PbList<UpdateTask>();
  @$core.pragma('dart2js:noInline')
  static UpdateTask getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateTask>(create);
  static UpdateTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  Task get task => $_getN(1);
  @$pb.TagNumber(2)
  set task(Task value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTask() => $_has(1);
  @$pb.TagNumber(2)
  void clearTask() => $_clearField(2);
  @$pb.TagNumber(2)
  Task ensureTask() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.FieldMask get updateMask => $_getN(2);
  @$pb.TagNumber(3)
  set updateMask($1.FieldMask value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpdateMask() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdateMask() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.FieldMask ensureUpdateMask() => $_ensure(2);
}

class DeleteTask extends $pb.GeneratedMessage {
  factory DeleteTask({
    $core.String? listId,
    $core.String? taskId,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (taskId != null) result.taskId = taskId;
    return result;
  }

  DeleteTask._();

  factory DeleteTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteTask',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'taskId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTask clone() => DeleteTask()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteTask copyWith(void Function(DeleteTask) updates) =>
      super.copyWith((message) => updates(message as DeleteTask)) as DeleteTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTask create() => DeleteTask._();
  @$core.override
  DeleteTask createEmptyInstance() => create();
  static $pb.PbList<DeleteTask> createRepeated() => $pb.PbList<DeleteTask>();
  @$core.pragma('dart2js:noInline')
  static DeleteTask getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteTask>(create);
  static DeleteTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskId => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaskId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskId() => $_clearField(2);
}

class RestoreTaskSubtree extends $pb.GeneratedMessage {
  factory RestoreTaskSubtree({
    $core.String? listId,
    $core.Iterable<Task>? tasks,
    $core.String? afterTaskId,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (tasks != null) result.tasks.addAll(tasks);
    if (afterTaskId != null) result.afterTaskId = afterTaskId;
    return result;
  }

  RestoreTaskSubtree._();

  factory RestoreTaskSubtree.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestoreTaskSubtree.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestoreTaskSubtree',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..pc<Task>(2, _omitFieldNames ? '' : 'tasks', $pb.PbFieldType.PM,
        subBuilder: Task.create)
    ..aOS(3, _omitFieldNames ? '' : 'afterTaskId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreTaskSubtree clone() => RestoreTaskSubtree()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreTaskSubtree copyWith(void Function(RestoreTaskSubtree) updates) =>
      super.copyWith((message) => updates(message as RestoreTaskSubtree))
          as RestoreTaskSubtree;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestoreTaskSubtree create() => RestoreTaskSubtree._();
  @$core.override
  RestoreTaskSubtree createEmptyInstance() => create();
  static $pb.PbList<RestoreTaskSubtree> createRepeated() =>
      $pb.PbList<RestoreTaskSubtree>();
  @$core.pragma('dart2js:noInline')
  static RestoreTaskSubtree getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestoreTaskSubtree>(create);
  static RestoreTaskSubtree? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Task> get tasks => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get afterTaskId => $_getSZ(2);
  @$pb.TagNumber(3)
  set afterTaskId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAfterTaskId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfterTaskId() => $_clearField(3);
}

class MoveTask extends $pb.GeneratedMessage {
  factory MoveTask({
    $core.String? listId,
    $core.String? taskId,
    $core.String? parentId,
    $core.String? afterTaskId,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (taskId != null) result.taskId = taskId;
    if (parentId != null) result.parentId = parentId;
    if (afterTaskId != null) result.afterTaskId = afterTaskId;
    return result;
  }

  MoveTask._();

  factory MoveTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoveTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveTask',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'taskId')
    ..aOS(3, _omitFieldNames ? '' : 'parentId')
    ..aOS(4, _omitFieldNames ? '' : 'afterTaskId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveTask clone() => MoveTask()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveTask copyWith(void Function(MoveTask) updates) =>
      super.copyWith((message) => updates(message as MoveTask)) as MoveTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveTask create() => MoveTask._();
  @$core.override
  MoveTask createEmptyInstance() => create();
  static $pb.PbList<MoveTask> createRepeated() => $pb.PbList<MoveTask>();
  @$core.pragma('dart2js:noInline')
  static MoveTask getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoveTask>(create);
  static MoveTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskId => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaskId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get parentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasParentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get afterTaskId => $_getSZ(3);
  @$pb.TagNumber(4)
  set afterTaskId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAfterTaskId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAfterTaskId() => $_clearField(4);
}

class SetTaskStatus extends $pb.GeneratedMessage {
  factory SetTaskStatus({
    $core.String? listId,
    $core.String? taskId,
    TaskStatus? status,
    $core.bool? includeDescendants,
    $0.Timestamp? changedAt,
    StatusChangeReason? reason,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (taskId != null) result.taskId = taskId;
    if (status != null) result.status = status;
    if (includeDescendants != null)
      result.includeDescendants = includeDescendants;
    if (changedAt != null) result.changedAt = changedAt;
    if (reason != null) result.reason = reason;
    return result;
  }

  SetTaskStatus._();

  factory SetTaskStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetTaskStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetTaskStatus',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'taskId')
    ..e<TaskStatus>(3, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: TaskStatus.TASK_STATUS_UNSPECIFIED,
        valueOf: TaskStatus.valueOf,
        enumValues: TaskStatus.values)
    ..aOB(4, _omitFieldNames ? '' : 'includeDescendants')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'changedAt',
        subBuilder: $0.Timestamp.create)
    ..e<StatusChangeReason>(
        6, _omitFieldNames ? '' : 'reason', $pb.PbFieldType.OE,
        defaultOrMaker: StatusChangeReason.STATUS_CHANGE_REASON_UNSPECIFIED,
        valueOf: StatusChangeReason.valueOf,
        enumValues: StatusChangeReason.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTaskStatus clone() => SetTaskStatus()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTaskStatus copyWith(void Function(SetTaskStatus) updates) =>
      super.copyWith((message) => updates(message as SetTaskStatus))
          as SetTaskStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetTaskStatus create() => SetTaskStatus._();
  @$core.override
  SetTaskStatus createEmptyInstance() => create();
  static $pb.PbList<SetTaskStatus> createRepeated() =>
      $pb.PbList<SetTaskStatus>();
  @$core.pragma('dart2js:noInline')
  static SetTaskStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetTaskStatus>(create);
  static SetTaskStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskId => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaskId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskId() => $_clearField(2);

  @$pb.TagNumber(3)
  TaskStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(TaskStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get includeDescendants => $_getBF(3);
  @$pb.TagNumber(4)
  set includeDescendants($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIncludeDescendants() => $_has(3);
  @$pb.TagNumber(4)
  void clearIncludeDescendants() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get changedAt => $_getN(4);
  @$pb.TagNumber(5)
  set changedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasChangedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearChangedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureChangedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  StatusChangeReason get reason => $_getN(5);
  @$pb.TagNumber(6)
  set reason(StatusChangeReason value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);
}

class AddCompletionEvent extends $pb.GeneratedMessage {
  factory AddCompletionEvent({
    $core.String? listId,
    $core.String? taskId,
    CompletionEvent? event,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (taskId != null) result.taskId = taskId;
    if (event != null) result.event = event;
    return result;
  }

  AddCompletionEvent._();

  factory AddCompletionEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddCompletionEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddCompletionEvent',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'taskId')
    ..aOM<CompletionEvent>(3, _omitFieldNames ? '' : 'event',
        subBuilder: CompletionEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddCompletionEvent clone() => AddCompletionEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddCompletionEvent copyWith(void Function(AddCompletionEvent) updates) =>
      super.copyWith((message) => updates(message as AddCompletionEvent))
          as AddCompletionEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddCompletionEvent create() => AddCompletionEvent._();
  @$core.override
  AddCompletionEvent createEmptyInstance() => create();
  static $pb.PbList<AddCompletionEvent> createRepeated() =>
      $pb.PbList<AddCompletionEvent>();
  @$core.pragma('dart2js:noInline')
  static AddCompletionEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddCompletionEvent>(create);
  static AddCompletionEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskId => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaskId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskId() => $_clearField(2);

  @$pb.TagNumber(3)
  CompletionEvent get event => $_getN(2);
  @$pb.TagNumber(3)
  set event(CompletionEvent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEvent() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvent() => $_clearField(3);
  @$pb.TagNumber(3)
  CompletionEvent ensureEvent() => $_ensure(2);
}

class RemoveCompletionEvent extends $pb.GeneratedMessage {
  factory RemoveCompletionEvent({
    $core.String? listId,
    $core.String? taskId,
    $core.String? eventId,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (taskId != null) result.taskId = taskId;
    if (eventId != null) result.eventId = eventId;
    return result;
  }

  RemoveCompletionEvent._();

  factory RemoveCompletionEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveCompletionEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveCompletionEvent',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'taskId')
    ..aOS(3, _omitFieldNames ? '' : 'eventId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveCompletionEvent clone() =>
      RemoveCompletionEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveCompletionEvent copyWith(
          void Function(RemoveCompletionEvent) updates) =>
      super.copyWith((message) => updates(message as RemoveCompletionEvent))
          as RemoveCompletionEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveCompletionEvent create() => RemoveCompletionEvent._();
  @$core.override
  RemoveCompletionEvent createEmptyInstance() => create();
  static $pb.PbList<RemoveCompletionEvent> createRepeated() =>
      $pb.PbList<RemoveCompletionEvent>();
  @$core.pragma('dart2js:noInline')
  static RemoveCompletionEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveCompletionEvent>(create);
  static RemoveCompletionEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskId => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaskId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get eventId => $_getSZ(2);
  @$pb.TagNumber(3)
  set eventId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEventId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEventId() => $_clearField(3);
}

class ResetDailyTask extends $pb.GeneratedMessage {
  factory ResetDailyTask({
    $core.String? listId,
    $core.String? taskId,
    $core.String? logicalDate,
    $0.Timestamp? changedAt,
  }) {
    final result = create();
    if (listId != null) result.listId = listId;
    if (taskId != null) result.taskId = taskId;
    if (logicalDate != null) result.logicalDate = logicalDate;
    if (changedAt != null) result.changedAt = changedAt;
    return result;
  }

  ResetDailyTask._();

  factory ResetDailyTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResetDailyTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetDailyTask',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'listId')
    ..aOS(2, _omitFieldNames ? '' : 'taskId')
    ..aOS(3, _omitFieldNames ? '' : 'logicalDate')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'changedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetDailyTask clone() => ResetDailyTask()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetDailyTask copyWith(void Function(ResetDailyTask) updates) =>
      super.copyWith((message) => updates(message as ResetDailyTask))
          as ResetDailyTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetDailyTask create() => ResetDailyTask._();
  @$core.override
  ResetDailyTask createEmptyInstance() => create();
  static $pb.PbList<ResetDailyTask> createRepeated() =>
      $pb.PbList<ResetDailyTask>();
  @$core.pragma('dart2js:noInline')
  static ResetDailyTask getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetDailyTask>(create);
  static ResetDailyTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get listId => $_getSZ(0);
  @$pb.TagNumber(1)
  set listId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListId() => $_has(0);
  @$pb.TagNumber(1)
  void clearListId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskId => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaskId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get logicalDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set logicalDate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLogicalDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearLogicalDate() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get changedAt => $_getN(3);
  @$pb.TagNumber(4)
  set changedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasChangedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearChangedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureChangedAt() => $_ensure(3);
}

enum Operation_Value {
  createList,
  renameList,
  deleteList,
  restoreList,
  moveList,
  createTask,
  updateTask,
  deleteTask,
  restoreTaskSubtree,
  moveTask,
  setTaskStatus,
  addCompletionEvent,
  removeCompletionEvent,
  resetDailyTask,
  notSet
}

class Operation extends $pb.GeneratedMessage {
  factory Operation({
    CreateList? createList,
    RenameList? renameList,
    DeleteList? deleteList,
    RestoreList? restoreList,
    MoveList? moveList,
    CreateTask? createTask,
    UpdateTask? updateTask,
    DeleteTask? deleteTask,
    RestoreTaskSubtree? restoreTaskSubtree,
    MoveTask? moveTask,
    SetTaskStatus? setTaskStatus,
    AddCompletionEvent? addCompletionEvent,
    RemoveCompletionEvent? removeCompletionEvent,
    ResetDailyTask? resetDailyTask,
  }) {
    final result = create();
    if (createList != null) result.createList = createList;
    if (renameList != null) result.renameList = renameList;
    if (deleteList != null) result.deleteList = deleteList;
    if (restoreList != null) result.restoreList = restoreList;
    if (moveList != null) result.moveList = moveList;
    if (createTask != null) result.createTask = createTask;
    if (updateTask != null) result.updateTask = updateTask;
    if (deleteTask != null) result.deleteTask = deleteTask;
    if (restoreTaskSubtree != null)
      result.restoreTaskSubtree = restoreTaskSubtree;
    if (moveTask != null) result.moveTask = moveTask;
    if (setTaskStatus != null) result.setTaskStatus = setTaskStatus;
    if (addCompletionEvent != null)
      result.addCompletionEvent = addCompletionEvent;
    if (removeCompletionEvent != null)
      result.removeCompletionEvent = removeCompletionEvent;
    if (resetDailyTask != null) result.resetDailyTask = resetDailyTask;
    return result;
  }

  Operation._();

  factory Operation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Operation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Operation_Value> _Operation_ValueByTag = {
    1: Operation_Value.createList,
    2: Operation_Value.renameList,
    3: Operation_Value.deleteList,
    4: Operation_Value.restoreList,
    5: Operation_Value.moveList,
    6: Operation_Value.createTask,
    7: Operation_Value.updateTask,
    8: Operation_Value.deleteTask,
    9: Operation_Value.restoreTaskSubtree,
    10: Operation_Value.moveTask,
    11: Operation_Value.setTaskStatus,
    12: Operation_Value.addCompletionEvent,
    13: Operation_Value.removeCompletionEvent,
    14: Operation_Value.resetDailyTask,
    0: Operation_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Operation',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
    ..aOM<CreateList>(1, _omitFieldNames ? '' : 'createList',
        subBuilder: CreateList.create)
    ..aOM<RenameList>(2, _omitFieldNames ? '' : 'renameList',
        subBuilder: RenameList.create)
    ..aOM<DeleteList>(3, _omitFieldNames ? '' : 'deleteList',
        subBuilder: DeleteList.create)
    ..aOM<RestoreList>(4, _omitFieldNames ? '' : 'restoreList',
        subBuilder: RestoreList.create)
    ..aOM<MoveList>(5, _omitFieldNames ? '' : 'moveList',
        subBuilder: MoveList.create)
    ..aOM<CreateTask>(6, _omitFieldNames ? '' : 'createTask',
        subBuilder: CreateTask.create)
    ..aOM<UpdateTask>(7, _omitFieldNames ? '' : 'updateTask',
        subBuilder: UpdateTask.create)
    ..aOM<DeleteTask>(8, _omitFieldNames ? '' : 'deleteTask',
        subBuilder: DeleteTask.create)
    ..aOM<RestoreTaskSubtree>(9, _omitFieldNames ? '' : 'restoreTaskSubtree',
        subBuilder: RestoreTaskSubtree.create)
    ..aOM<MoveTask>(10, _omitFieldNames ? '' : 'moveTask',
        subBuilder: MoveTask.create)
    ..aOM<SetTaskStatus>(11, _omitFieldNames ? '' : 'setTaskStatus',
        subBuilder: SetTaskStatus.create)
    ..aOM<AddCompletionEvent>(12, _omitFieldNames ? '' : 'addCompletionEvent',
        subBuilder: AddCompletionEvent.create)
    ..aOM<RemoveCompletionEvent>(
        13, _omitFieldNames ? '' : 'removeCompletionEvent',
        subBuilder: RemoveCompletionEvent.create)
    ..aOM<ResetDailyTask>(14, _omitFieldNames ? '' : 'resetDailyTask',
        subBuilder: ResetDailyTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Operation clone() => Operation()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Operation copyWith(void Function(Operation) updates) =>
      super.copyWith((message) => updates(message as Operation)) as Operation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Operation create() => Operation._();
  @$core.override
  Operation createEmptyInstance() => create();
  static $pb.PbList<Operation> createRepeated() => $pb.PbList<Operation>();
  @$core.pragma('dart2js:noInline')
  static Operation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Operation>(create);
  static Operation? _defaultInstance;

  Operation_Value whichValue() => _Operation_ValueByTag[$_whichOneof(0)]!;
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CreateList get createList => $_getN(0);
  @$pb.TagNumber(1)
  set createList(CreateList value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCreateList() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreateList() => $_clearField(1);
  @$pb.TagNumber(1)
  CreateList ensureCreateList() => $_ensure(0);

  @$pb.TagNumber(2)
  RenameList get renameList => $_getN(1);
  @$pb.TagNumber(2)
  set renameList(RenameList value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRenameList() => $_has(1);
  @$pb.TagNumber(2)
  void clearRenameList() => $_clearField(2);
  @$pb.TagNumber(2)
  RenameList ensureRenameList() => $_ensure(1);

  @$pb.TagNumber(3)
  DeleteList get deleteList => $_getN(2);
  @$pb.TagNumber(3)
  set deleteList(DeleteList value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDeleteList() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeleteList() => $_clearField(3);
  @$pb.TagNumber(3)
  DeleteList ensureDeleteList() => $_ensure(2);

  @$pb.TagNumber(4)
  RestoreList get restoreList => $_getN(3);
  @$pb.TagNumber(4)
  set restoreList(RestoreList value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRestoreList() => $_has(3);
  @$pb.TagNumber(4)
  void clearRestoreList() => $_clearField(4);
  @$pb.TagNumber(4)
  RestoreList ensureRestoreList() => $_ensure(3);

  @$pb.TagNumber(5)
  MoveList get moveList => $_getN(4);
  @$pb.TagNumber(5)
  set moveList(MoveList value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMoveList() => $_has(4);
  @$pb.TagNumber(5)
  void clearMoveList() => $_clearField(5);
  @$pb.TagNumber(5)
  MoveList ensureMoveList() => $_ensure(4);

  @$pb.TagNumber(6)
  CreateTask get createTask => $_getN(5);
  @$pb.TagNumber(6)
  set createTask(CreateTask value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCreateTask() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreateTask() => $_clearField(6);
  @$pb.TagNumber(6)
  CreateTask ensureCreateTask() => $_ensure(5);

  @$pb.TagNumber(7)
  UpdateTask get updateTask => $_getN(6);
  @$pb.TagNumber(7)
  set updateTask(UpdateTask value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUpdateTask() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdateTask() => $_clearField(7);
  @$pb.TagNumber(7)
  UpdateTask ensureUpdateTask() => $_ensure(6);

  @$pb.TagNumber(8)
  DeleteTask get deleteTask => $_getN(7);
  @$pb.TagNumber(8)
  set deleteTask(DeleteTask value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDeleteTask() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeleteTask() => $_clearField(8);
  @$pb.TagNumber(8)
  DeleteTask ensureDeleteTask() => $_ensure(7);

  @$pb.TagNumber(9)
  RestoreTaskSubtree get restoreTaskSubtree => $_getN(8);
  @$pb.TagNumber(9)
  set restoreTaskSubtree(RestoreTaskSubtree value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRestoreTaskSubtree() => $_has(8);
  @$pb.TagNumber(9)
  void clearRestoreTaskSubtree() => $_clearField(9);
  @$pb.TagNumber(9)
  RestoreTaskSubtree ensureRestoreTaskSubtree() => $_ensure(8);

  @$pb.TagNumber(10)
  MoveTask get moveTask => $_getN(9);
  @$pb.TagNumber(10)
  set moveTask(MoveTask value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasMoveTask() => $_has(9);
  @$pb.TagNumber(10)
  void clearMoveTask() => $_clearField(10);
  @$pb.TagNumber(10)
  MoveTask ensureMoveTask() => $_ensure(9);

  @$pb.TagNumber(11)
  SetTaskStatus get setTaskStatus => $_getN(10);
  @$pb.TagNumber(11)
  set setTaskStatus(SetTaskStatus value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasSetTaskStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearSetTaskStatus() => $_clearField(11);
  @$pb.TagNumber(11)
  SetTaskStatus ensureSetTaskStatus() => $_ensure(10);

  @$pb.TagNumber(12)
  AddCompletionEvent get addCompletionEvent => $_getN(11);
  @$pb.TagNumber(12)
  set addCompletionEvent(AddCompletionEvent value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAddCompletionEvent() => $_has(11);
  @$pb.TagNumber(12)
  void clearAddCompletionEvent() => $_clearField(12);
  @$pb.TagNumber(12)
  AddCompletionEvent ensureAddCompletionEvent() => $_ensure(11);

  @$pb.TagNumber(13)
  RemoveCompletionEvent get removeCompletionEvent => $_getN(12);
  @$pb.TagNumber(13)
  set removeCompletionEvent(RemoveCompletionEvent value) =>
      $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRemoveCompletionEvent() => $_has(12);
  @$pb.TagNumber(13)
  void clearRemoveCompletionEvent() => $_clearField(13);
  @$pb.TagNumber(13)
  RemoveCompletionEvent ensureRemoveCompletionEvent() => $_ensure(12);

  @$pb.TagNumber(14)
  ResetDailyTask get resetDailyTask => $_getN(13);
  @$pb.TagNumber(14)
  set resetDailyTask(ResetDailyTask value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasResetDailyTask() => $_has(13);
  @$pb.TagNumber(14)
  void clearResetDailyTask() => $_clearField(14);
  @$pb.TagNumber(14)
  ResetDailyTask ensureResetDailyTask() => $_ensure(13);
}

class WorkspaceMutation extends $pb.GeneratedMessage {
  factory WorkspaceMutation({
    $core.String? mutationId,
    $core.String? deviceId,
    $fixnum.Int64? baseWorkspaceRevision,
    $core.Iterable<ResourceVersion>? baseListVersions,
    $0.Timestamp? createdAt,
    $core.Iterable<Operation>? operations,
  }) {
    final result = create();
    if (mutationId != null) result.mutationId = mutationId;
    if (deviceId != null) result.deviceId = deviceId;
    if (baseWorkspaceRevision != null)
      result.baseWorkspaceRevision = baseWorkspaceRevision;
    if (baseListVersions != null)
      result.baseListVersions.addAll(baseListVersions);
    if (createdAt != null) result.createdAt = createdAt;
    if (operations != null) result.operations.addAll(operations);
    return result;
  }

  WorkspaceMutation._();

  factory WorkspaceMutation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkspaceMutation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkspaceMutation',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mutationId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceId')
    ..aInt64(3, _omitFieldNames ? '' : 'baseWorkspaceRevision')
    ..pc<ResourceVersion>(
        4, _omitFieldNames ? '' : 'baseListVersions', $pb.PbFieldType.PM,
        subBuilder: ResourceVersion.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..pc<Operation>(6, _omitFieldNames ? '' : 'operations', $pb.PbFieldType.PM,
        subBuilder: Operation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkspaceMutation clone() => WorkspaceMutation()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkspaceMutation copyWith(void Function(WorkspaceMutation) updates) =>
      super.copyWith((message) => updates(message as WorkspaceMutation))
          as WorkspaceMutation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkspaceMutation create() => WorkspaceMutation._();
  @$core.override
  WorkspaceMutation createEmptyInstance() => create();
  static $pb.PbList<WorkspaceMutation> createRepeated() =>
      $pb.PbList<WorkspaceMutation>();
  @$core.pragma('dart2js:noInline')
  static WorkspaceMutation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkspaceMutation>(create);
  static WorkspaceMutation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mutationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mutationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMutationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMutationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get baseWorkspaceRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set baseWorkspaceRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBaseWorkspaceRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearBaseWorkspaceRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ResourceVersion> get baseListVersions => $_getList(3);

  @$pb.TagNumber(5)
  $0.Timestamp get createdAt => $_getN(4);
  @$pb.TagNumber(5)
  set createdAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureCreatedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<Operation> get operations => $_getList(5);
}

class MutationResult extends $pb.GeneratedMessage {
  factory MutationResult({
    $core.String? mutationId,
    MutationResultStatus? status,
    $fixnum.Int64? workspaceRevision,
    $core.Iterable<ResourceVersion>? listVersions,
    $core.Iterable<TaskList>? changedLists,
    $core.Iterable<$core.String>? deletedListIds,
    $core.String? message,
  }) {
    final result = create();
    if (mutationId != null) result.mutationId = mutationId;
    if (status != null) result.status = status;
    if (workspaceRevision != null) result.workspaceRevision = workspaceRevision;
    if (listVersions != null) result.listVersions.addAll(listVersions);
    if (changedLists != null) result.changedLists.addAll(changedLists);
    if (deletedListIds != null) result.deletedListIds.addAll(deletedListIds);
    if (message != null) result.message = message;
    return result;
  }

  MutationResult._();

  factory MutationResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MutationResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MutationResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mutationId')
    ..e<MutationResultStatus>(
        2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: MutationResultStatus.MUTATION_RESULT_STATUS_UNSPECIFIED,
        valueOf: MutationResultStatus.valueOf,
        enumValues: MutationResultStatus.values)
    ..aInt64(3, _omitFieldNames ? '' : 'workspaceRevision')
    ..pc<ResourceVersion>(
        4, _omitFieldNames ? '' : 'listVersions', $pb.PbFieldType.PM,
        subBuilder: ResourceVersion.create)
    ..pc<TaskList>(5, _omitFieldNames ? '' : 'changedLists', $pb.PbFieldType.PM,
        subBuilder: TaskList.create)
    ..pPS(6, _omitFieldNames ? '' : 'deletedListIds')
    ..aOS(7, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MutationResult clone() => MutationResult()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MutationResult copyWith(void Function(MutationResult) updates) =>
      super.copyWith((message) => updates(message as MutationResult))
          as MutationResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MutationResult create() => MutationResult._();
  @$core.override
  MutationResult createEmptyInstance() => create();
  static $pb.PbList<MutationResult> createRepeated() =>
      $pb.PbList<MutationResult>();
  @$core.pragma('dart2js:noInline')
  static MutationResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MutationResult>(create);
  static MutationResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mutationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mutationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMutationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMutationId() => $_clearField(1);

  @$pb.TagNumber(2)
  MutationResultStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(MutationResultStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get workspaceRevision => $_getI64(2);
  @$pb.TagNumber(3)
  set workspaceRevision($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceRevision() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceRevision() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ResourceVersion> get listVersions => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<TaskList> get changedLists => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get deletedListIds => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get message => $_getSZ(6);
  @$pb.TagNumber(7)
  set message($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearMessage() => $_clearField(7);
}

class WorkspaceSnapshot extends $pb.GeneratedMessage {
  factory WorkspaceSnapshot({
    $fixnum.Int64? workspaceRevision,
    $fixnum.Int64? historyFloorRevision,
    $core.String? accountTimezone,
    $core.Iterable<TaskList>? lists,
  }) {
    final result = create();
    if (workspaceRevision != null) result.workspaceRevision = workspaceRevision;
    if (historyFloorRevision != null)
      result.historyFloorRevision = historyFloorRevision;
    if (accountTimezone != null) result.accountTimezone = accountTimezone;
    if (lists != null) result.lists.addAll(lists);
    return result;
  }

  WorkspaceSnapshot._();

  factory WorkspaceSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkspaceSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkspaceSnapshot',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'workspaceRevision')
    ..aInt64(2, _omitFieldNames ? '' : 'historyFloorRevision')
    ..aOS(3, _omitFieldNames ? '' : 'accountTimezone')
    ..pc<TaskList>(4, _omitFieldNames ? '' : 'lists', $pb.PbFieldType.PM,
        subBuilder: TaskList.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkspaceSnapshot clone() => WorkspaceSnapshot()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkspaceSnapshot copyWith(void Function(WorkspaceSnapshot) updates) =>
      super.copyWith((message) => updates(message as WorkspaceSnapshot))
          as WorkspaceSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkspaceSnapshot create() => WorkspaceSnapshot._();
  @$core.override
  WorkspaceSnapshot createEmptyInstance() => create();
  static $pb.PbList<WorkspaceSnapshot> createRepeated() =>
      $pb.PbList<WorkspaceSnapshot>();
  @$core.pragma('dart2js:noInline')
  static WorkspaceSnapshot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkspaceSnapshot>(create);
  static WorkspaceSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get workspaceRevision => $_getI64(0);
  @$pb.TagNumber(1)
  set workspaceRevision($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceRevision() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get historyFloorRevision => $_getI64(1);
  @$pb.TagNumber(2)
  set historyFloorRevision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHistoryFloorRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearHistoryFloorRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get accountTimezone => $_getSZ(2);
  @$pb.TagNumber(3)
  set accountTimezone($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAccountTimezone() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountTimezone() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<TaskList> get lists => $_getList(3);
}

class GetSnapshotRequest extends $pb.GeneratedMessage {
  factory GetSnapshotRequest() => create();

  GetSnapshotRequest._();

  factory GetSnapshotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSnapshotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSnapshotRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSnapshotRequest clone() => GetSnapshotRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSnapshotRequest copyWith(void Function(GetSnapshotRequest) updates) =>
      super.copyWith((message) => updates(message as GetSnapshotRequest))
          as GetSnapshotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSnapshotRequest create() => GetSnapshotRequest._();
  @$core.override
  GetSnapshotRequest createEmptyInstance() => create();
  static $pb.PbList<GetSnapshotRequest> createRepeated() =>
      $pb.PbList<GetSnapshotRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSnapshotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSnapshotRequest>(create);
  static GetSnapshotRequest? _defaultInstance;
}

class GetSnapshotResponse extends $pb.GeneratedMessage {
  factory GetSnapshotResponse({
    WorkspaceSnapshot? snapshot,
  }) {
    final result = create();
    if (snapshot != null) result.snapshot = snapshot;
    return result;
  }

  GetSnapshotResponse._();

  factory GetSnapshotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSnapshotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSnapshotResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOM<WorkspaceSnapshot>(1, _omitFieldNames ? '' : 'snapshot',
        subBuilder: WorkspaceSnapshot.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSnapshotResponse clone() => GetSnapshotResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSnapshotResponse copyWith(void Function(GetSnapshotResponse) updates) =>
      super.copyWith((message) => updates(message as GetSnapshotResponse))
          as GetSnapshotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSnapshotResponse create() => GetSnapshotResponse._();
  @$core.override
  GetSnapshotResponse createEmptyInstance() => create();
  static $pb.PbList<GetSnapshotResponse> createRepeated() =>
      $pb.PbList<GetSnapshotResponse>();
  @$core.pragma('dart2js:noInline')
  static GetSnapshotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSnapshotResponse>(create);
  static GetSnapshotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkspaceSnapshot get snapshot => $_getN(0);
  @$pb.TagNumber(1)
  set snapshot(WorkspaceSnapshot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshot() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkspaceSnapshot ensureSnapshot() => $_ensure(0);
}

class PullChangesRequest extends $pb.GeneratedMessage {
  factory PullChangesRequest({
    $fixnum.Int64? afterRevision,
    $core.int? limit,
  }) {
    final result = create();
    if (afterRevision != null) result.afterRevision = afterRevision;
    if (limit != null) result.limit = limit;
    return result;
  }

  PullChangesRequest._();

  factory PullChangesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PullChangesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PullChangesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'afterRevision')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullChangesRequest clone() => PullChangesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullChangesRequest copyWith(void Function(PullChangesRequest) updates) =>
      super.copyWith((message) => updates(message as PullChangesRequest))
          as PullChangesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullChangesRequest create() => PullChangesRequest._();
  @$core.override
  PullChangesRequest createEmptyInstance() => create();
  static $pb.PbList<PullChangesRequest> createRepeated() =>
      $pb.PbList<PullChangesRequest>();
  @$core.pragma('dart2js:noInline')
  static PullChangesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PullChangesRequest>(create);
  static PullChangesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get afterRevision => $_getI64(0);
  @$pb.TagNumber(1)
  set afterRevision($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAfterRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearAfterRevision() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class WorkspaceChange extends $pb.GeneratedMessage {
  factory WorkspaceChange({
    $fixnum.Int64? workspaceRevision,
    WorkspaceMutation? mutation,
    MutationResult? result,
  }) {
    final result$ = create();
    if (workspaceRevision != null)
      result$.workspaceRevision = workspaceRevision;
    if (mutation != null) result$.mutation = mutation;
    if (result != null) result$.result = result;
    return result$;
  }

  WorkspaceChange._();

  factory WorkspaceChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkspaceChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkspaceChange',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'workspaceRevision')
    ..aOM<WorkspaceMutation>(2, _omitFieldNames ? '' : 'mutation',
        subBuilder: WorkspaceMutation.create)
    ..aOM<MutationResult>(3, _omitFieldNames ? '' : 'result',
        subBuilder: MutationResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkspaceChange clone() => WorkspaceChange()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkspaceChange copyWith(void Function(WorkspaceChange) updates) =>
      super.copyWith((message) => updates(message as WorkspaceChange))
          as WorkspaceChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkspaceChange create() => WorkspaceChange._();
  @$core.override
  WorkspaceChange createEmptyInstance() => create();
  static $pb.PbList<WorkspaceChange> createRepeated() =>
      $pb.PbList<WorkspaceChange>();
  @$core.pragma('dart2js:noInline')
  static WorkspaceChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkspaceChange>(create);
  static WorkspaceChange? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get workspaceRevision => $_getI64(0);
  @$pb.TagNumber(1)
  set workspaceRevision($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceRevision() => $_clearField(1);

  @$pb.TagNumber(2)
  WorkspaceMutation get mutation => $_getN(1);
  @$pb.TagNumber(2)
  set mutation(WorkspaceMutation value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMutation() => $_has(1);
  @$pb.TagNumber(2)
  void clearMutation() => $_clearField(2);
  @$pb.TagNumber(2)
  WorkspaceMutation ensureMutation() => $_ensure(1);

  @$pb.TagNumber(3)
  MutationResult get result => $_getN(2);
  @$pb.TagNumber(3)
  set result(MutationResult value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasResult() => $_has(2);
  @$pb.TagNumber(3)
  void clearResult() => $_clearField(3);
  @$pb.TagNumber(3)
  MutationResult ensureResult() => $_ensure(2);
}

class PullChangesResponse extends $pb.GeneratedMessage {
  factory PullChangesResponse({
    $fixnum.Int64? currentRevision,
    $fixnum.Int64? historyFloorRevision,
    $core.bool? resetRequired,
    $core.Iterable<WorkspaceChange>? changes,
  }) {
    final result = create();
    if (currentRevision != null) result.currentRevision = currentRevision;
    if (historyFloorRevision != null)
      result.historyFloorRevision = historyFloorRevision;
    if (resetRequired != null) result.resetRequired = resetRequired;
    if (changes != null) result.changes.addAll(changes);
    return result;
  }

  PullChangesResponse._();

  factory PullChangesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PullChangesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PullChangesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'currentRevision')
    ..aInt64(2, _omitFieldNames ? '' : 'historyFloorRevision')
    ..aOB(3, _omitFieldNames ? '' : 'resetRequired')
    ..pc<WorkspaceChange>(
        4, _omitFieldNames ? '' : 'changes', $pb.PbFieldType.PM,
        subBuilder: WorkspaceChange.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullChangesResponse clone() => PullChangesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullChangesResponse copyWith(void Function(PullChangesResponse) updates) =>
      super.copyWith((message) => updates(message as PullChangesResponse))
          as PullChangesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullChangesResponse create() => PullChangesResponse._();
  @$core.override
  PullChangesResponse createEmptyInstance() => create();
  static $pb.PbList<PullChangesResponse> createRepeated() =>
      $pb.PbList<PullChangesResponse>();
  @$core.pragma('dart2js:noInline')
  static PullChangesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PullChangesResponse>(create);
  static PullChangesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get currentRevision => $_getI64(0);
  @$pb.TagNumber(1)
  set currentRevision($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentRevision() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get historyFloorRevision => $_getI64(1);
  @$pb.TagNumber(2)
  set historyFloorRevision($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHistoryFloorRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearHistoryFloorRevision() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get resetRequired => $_getBF(2);
  @$pb.TagNumber(3)
  set resetRequired($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResetRequired() => $_has(2);
  @$pb.TagNumber(3)
  void clearResetRequired() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<WorkspaceChange> get changes => $_getList(3);
}

class PushMutationsRequest extends $pb.GeneratedMessage {
  factory PushMutationsRequest({
    $core.Iterable<WorkspaceMutation>? mutations,
  }) {
    final result = create();
    if (mutations != null) result.mutations.addAll(mutations);
    return result;
  }

  PushMutationsRequest._();

  factory PushMutationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushMutationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PushMutationsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..pc<WorkspaceMutation>(
        1, _omitFieldNames ? '' : 'mutations', $pb.PbFieldType.PM,
        subBuilder: WorkspaceMutation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushMutationsRequest clone() =>
      PushMutationsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushMutationsRequest copyWith(void Function(PushMutationsRequest) updates) =>
      super.copyWith((message) => updates(message as PushMutationsRequest))
          as PushMutationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushMutationsRequest create() => PushMutationsRequest._();
  @$core.override
  PushMutationsRequest createEmptyInstance() => create();
  static $pb.PbList<PushMutationsRequest> createRepeated() =>
      $pb.PbList<PushMutationsRequest>();
  @$core.pragma('dart2js:noInline')
  static PushMutationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PushMutationsRequest>(create);
  static PushMutationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WorkspaceMutation> get mutations => $_getList(0);
}

class PushMutationsResponse extends $pb.GeneratedMessage {
  factory PushMutationsResponse({
    $core.Iterable<MutationResult>? results,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    return result;
  }

  PushMutationsResponse._();

  factory PushMutationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushMutationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PushMutationsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..pc<MutationResult>(
        1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM,
        subBuilder: MutationResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushMutationsResponse clone() =>
      PushMutationsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushMutationsResponse copyWith(
          void Function(PushMutationsResponse) updates) =>
      super.copyWith((message) => updates(message as PushMutationsResponse))
          as PushMutationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushMutationsResponse create() => PushMutationsResponse._();
  @$core.override
  PushMutationsResponse createEmptyInstance() => create();
  static $pb.PbList<PushMutationsResponse> createRepeated() =>
      $pb.PbList<PushMutationsResponse>();
  @$core.pragma('dart2js:noInline')
  static PushMutationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PushMutationsResponse>(create);
  static PushMutationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MutationResult> get results => $_getList(0);
}

class UpdateWorkspaceSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateWorkspaceSettingsRequest({
    $core.String? accountTimezone,
  }) {
    final result = create();
    if (accountTimezone != null) result.accountTimezone = accountTimezone;
    return result;
  }

  UpdateWorkspaceSettingsRequest._();

  factory UpdateWorkspaceSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateWorkspaceSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateWorkspaceSettingsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountTimezone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateWorkspaceSettingsRequest clone() =>
      UpdateWorkspaceSettingsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateWorkspaceSettingsRequest copyWith(
          void Function(UpdateWorkspaceSettingsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateWorkspaceSettingsRequest))
          as UpdateWorkspaceSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateWorkspaceSettingsRequest create() =>
      UpdateWorkspaceSettingsRequest._();
  @$core.override
  UpdateWorkspaceSettingsRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateWorkspaceSettingsRequest> createRepeated() =>
      $pb.PbList<UpdateWorkspaceSettingsRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateWorkspaceSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateWorkspaceSettingsRequest>(create);
  static UpdateWorkspaceSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountTimezone => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountTimezone($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountTimezone() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountTimezone() => $_clearField(1);
}

class UpdateWorkspaceSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateWorkspaceSettingsResponse({
    $fixnum.Int64? workspaceRevision,
    $core.String? accountTimezone,
  }) {
    final result = create();
    if (workspaceRevision != null) result.workspaceRevision = workspaceRevision;
    if (accountTimezone != null) result.accountTimezone = accountTimezone;
    return result;
  }

  UpdateWorkspaceSettingsResponse._();

  factory UpdateWorkspaceSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateWorkspaceSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateWorkspaceSettingsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'workspaceRevision')
    ..aOS(2, _omitFieldNames ? '' : 'accountTimezone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateWorkspaceSettingsResponse clone() =>
      UpdateWorkspaceSettingsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateWorkspaceSettingsResponse copyWith(
          void Function(UpdateWorkspaceSettingsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateWorkspaceSettingsResponse))
          as UpdateWorkspaceSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateWorkspaceSettingsResponse create() =>
      UpdateWorkspaceSettingsResponse._();
  @$core.override
  UpdateWorkspaceSettingsResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateWorkspaceSettingsResponse> createRepeated() =>
      $pb.PbList<UpdateWorkspaceSettingsResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateWorkspaceSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateWorkspaceSettingsResponse>(
          create);
  static UpdateWorkspaceSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get workspaceRevision => $_getI64(0);
  @$pb.TagNumber(1)
  set workspaceRevision($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceRevision() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountTimezone => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountTimezone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccountTimezone() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountTimezone() => $_clearField(2);
}

class WatchWorkspaceRequest extends $pb.GeneratedMessage {
  factory WatchWorkspaceRequest({
    $fixnum.Int64? afterRevision,
  }) {
    final result = create();
    if (afterRevision != null) result.afterRevision = afterRevision;
    return result;
  }

  WatchWorkspaceRequest._();

  factory WatchWorkspaceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchWorkspaceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchWorkspaceRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'afterRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchWorkspaceRequest clone() =>
      WatchWorkspaceRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchWorkspaceRequest copyWith(
          void Function(WatchWorkspaceRequest) updates) =>
      super.copyWith((message) => updates(message as WatchWorkspaceRequest))
          as WatchWorkspaceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchWorkspaceRequest create() => WatchWorkspaceRequest._();
  @$core.override
  WatchWorkspaceRequest createEmptyInstance() => create();
  static $pb.PbList<WatchWorkspaceRequest> createRepeated() =>
      $pb.PbList<WatchWorkspaceRequest>();
  @$core.pragma('dart2js:noInline')
  static WatchWorkspaceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchWorkspaceRequest>(create);
  static WatchWorkspaceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get afterRevision => $_getI64(0);
  @$pb.TagNumber(1)
  set afterRevision($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAfterRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearAfterRevision() => $_clearField(1);
}

class WatchWorkspaceResponse extends $pb.GeneratedMessage {
  factory WatchWorkspaceResponse({
    $fixnum.Int64? workspaceRevision,
  }) {
    final result = create();
    if (workspaceRevision != null) result.workspaceRevision = workspaceRevision;
    return result;
  }

  WatchWorkspaceResponse._();

  factory WatchWorkspaceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchWorkspaceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchWorkspaceResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'workspaceRevision')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchWorkspaceResponse clone() =>
      WatchWorkspaceResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchWorkspaceResponse copyWith(
          void Function(WatchWorkspaceResponse) updates) =>
      super.copyWith((message) => updates(message as WatchWorkspaceResponse))
          as WatchWorkspaceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchWorkspaceResponse create() => WatchWorkspaceResponse._();
  @$core.override
  WatchWorkspaceResponse createEmptyInstance() => create();
  static $pb.PbList<WatchWorkspaceResponse> createRepeated() =>
      $pb.PbList<WatchWorkspaceResponse>();
  @$core.pragma('dart2js:noInline')
  static WatchWorkspaceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchWorkspaceResponse>(create);
  static WatchWorkspaceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get workspaceRevision => $_getI64(0);
  @$pb.TagNumber(1)
  set workspaceRevision($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceRevision() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceRevision() => $_clearField(1);
}

class PingRequest extends $pb.GeneratedMessage {
  factory PingRequest() => create();

  PingRequest._();

  factory PingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PingRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingRequest clone() => PingRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingRequest copyWith(void Function(PingRequest) updates) =>
      super.copyWith((message) => updates(message as PingRequest))
          as PingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingRequest create() => PingRequest._();
  @$core.override
  PingRequest createEmptyInstance() => create();
  static $pb.PbList<PingRequest> createRepeated() => $pb.PbList<PingRequest>();
  @$core.pragma('dart2js:noInline')
  static PingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PingRequest>(create);
  static PingRequest? _defaultInstance;
}

class PingResponse extends $pb.GeneratedMessage {
  factory PingResponse() => create();

  PingResponse._();

  factory PingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PingResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'lasttask.sync.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingResponse clone() => PingResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingResponse copyWith(void Function(PingResponse) updates) =>
      super.copyWith((message) => updates(message as PingResponse))
          as PingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingResponse create() => PingResponse._();
  @$core.override
  PingResponse createEmptyInstance() => create();
  static $pb.PbList<PingResponse> createRepeated() =>
      $pb.PbList<PingResponse>();
  @$core.pragma('dart2js:noInline')
  static PingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PingResponse>(create);
  static PingResponse? _defaultInstance;
}

class WorkspaceSyncServiceApi {
  final $pb.RpcClient _client;

  WorkspaceSyncServiceApi(this._client);

  $async.Future<GetSnapshotResponse> getSnapshot(
          $pb.ClientContext? ctx, GetSnapshotRequest request) =>
      _client.invoke<GetSnapshotResponse>(ctx, 'WorkspaceSyncService',
          'GetSnapshot', request, GetSnapshotResponse());
  $async.Future<PullChangesResponse> pullChanges(
          $pb.ClientContext? ctx, PullChangesRequest request) =>
      _client.invoke<PullChangesResponse>(ctx, 'WorkspaceSyncService',
          'PullChanges', request, PullChangesResponse());
  $async.Future<PushMutationsResponse> pushMutations(
          $pb.ClientContext? ctx, PushMutationsRequest request) =>
      _client.invoke<PushMutationsResponse>(ctx, 'WorkspaceSyncService',
          'PushMutations', request, PushMutationsResponse());
  $async.Future<UpdateWorkspaceSettingsResponse> updateWorkspaceSettings(
          $pb.ClientContext? ctx, UpdateWorkspaceSettingsRequest request) =>
      _client.invoke<UpdateWorkspaceSettingsResponse>(
          ctx,
          'WorkspaceSyncService',
          'UpdateWorkspaceSettings',
          request,
          UpdateWorkspaceSettingsResponse());
  $async.Future<WatchWorkspaceResponse> watchWorkspace(
          $pb.ClientContext? ctx, WatchWorkspaceRequest request) =>
      _client.invoke<WatchWorkspaceResponse>(ctx, 'WorkspaceSyncService',
          'WatchWorkspace', request, WatchWorkspaceResponse());
  $async.Future<PingResponse> ping(
          $pb.ClientContext? ctx, PingRequest request) =>
      _client.invoke<PingResponse>(
          ctx, 'WorkspaceSyncService', 'Ping', request, PingResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
