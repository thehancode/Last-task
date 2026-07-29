// This is a generated file - do not edit.
//
// Generated from lasttask/sync/v1/sync.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../../google/protobuf/field_mask.pbjson.dart' as $1;
import '../../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use taskStatusDescriptor instead')
const TaskStatus$json = {
  '1': 'TaskStatus',
  '2': [
    {'1': 'TASK_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TASK_STATUS_PENDING', '2': 1},
    {'1': 'TASK_STATUS_DOING', '2': 2},
    {'1': 'TASK_STATUS_DONE', '2': 3},
    {'1': 'TASK_STATUS_ARCHIVED', '2': 4},
  ],
};

/// Descriptor for `TaskStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskStatusDescriptor = $convert.base64Decode(
    'CgpUYXNrU3RhdHVzEhsKF1RBU0tfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFwoTVEFTS19TVEFUVV'
    'NfUEVORElORxABEhUKEVRBU0tfU1RBVFVTX0RPSU5HEAISFAoQVEFTS19TVEFUVVNfRE9ORRAD'
    'EhgKFFRBU0tfU1RBVFVTX0FSQ0hJVkVEEAQ=');

@$core.Deprecated('Use taskTagDescriptor instead')
const TaskTag$json = {
  '1': 'TaskTag',
  '2': [
    {'1': 'TASK_TAG_UNSPECIFIED', '2': 0},
    {'1': 'TASK_TAG_SPADE', '2': 1},
    {'1': 'TASK_TAG_HEART', '2': 2},
    {'1': 'TASK_TAG_CLUB', '2': 3},
    {'1': 'TASK_TAG_DIAMOND', '2': 4},
  ],
};

/// Descriptor for `TaskTag`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskTagDescriptor = $convert.base64Decode(
    'CgdUYXNrVGFnEhgKFFRBU0tfVEFHX1VOU1BFQ0lGSUVEEAASEgoOVEFTS19UQUdfU1BBREUQAR'
    'ISCg5UQVNLX1RBR19IRUFSVBACEhEKDVRBU0tfVEFHX0NMVUIQAxIUChBUQVNLX1RBR19ESUFN'
    'T05EEAQ=');

@$core.Deprecated('Use mutationResultStatusDescriptor instead')
const MutationResultStatus$json = {
  '1': 'MutationResultStatus',
  '2': [
    {'1': 'MUTATION_RESULT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'MUTATION_RESULT_STATUS_APPLIED', '2': 1},
    {'1': 'MUTATION_RESULT_STATUS_ALREADY_APPLIED', '2': 2},
    {'1': 'MUTATION_RESULT_STATUS_NO_OP', '2': 3},
    {'1': 'MUTATION_RESULT_STATUS_REJECTED', '2': 4},
  ],
};

/// Descriptor for `MutationResultStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mutationResultStatusDescriptor = $convert.base64Decode(
    'ChRNdXRhdGlvblJlc3VsdFN0YXR1cxImCiJNVVRBVElPTl9SRVNVTFRfU1RBVFVTX1VOU1BFQ0'
    'lGSUVEEAASIgoeTVVUQVRJT05fUkVTVUxUX1NUQVRVU19BUFBMSUVEEAESKgomTVVUQVRJT05f'
    'UkVTVUxUX1NUQVRVU19BTFJFQURZX0FQUExJRUQQAhIgChxNVVRBVElPTl9SRVNVTFRfU1RBVF'
    'VTX05PX09QEAMSIwofTVVUQVRJT05fUkVTVUxUX1NUQVRVU19SRUpFQ1RFRBAE');

@$core.Deprecated('Use statusChangeReasonDescriptor instead')
const StatusChangeReason$json = {
  '1': 'StatusChangeReason',
  '2': [
    {'1': 'STATUS_CHANGE_REASON_UNSPECIFIED', '2': 0},
    {'1': 'STATUS_CHANGE_REASON_USER', '2': 1},
    {'1': 'STATUS_CHANGE_REASON_DAILY_RESET', '2': 2},
    {'1': 'STATUS_CHANGE_REASON_UNDO', '2': 3},
  ],
};

/// Descriptor for `StatusChangeReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List statusChangeReasonDescriptor = $convert.base64Decode(
    'ChJTdGF0dXNDaGFuZ2VSZWFzb24SJAogU1RBVFVTX0NIQU5HRV9SRUFTT05fVU5TUEVDSUZJRU'
    'QQABIdChlTVEFUVVNfQ0hBTkdFX1JFQVNPTl9VU0VSEAESJAogU1RBVFVTX0NIQU5HRV9SRUFT'
    'T05fREFJTFlfUkVTRVQQAhIdChlTVEFUVVNfQ0hBTkdFX1JFQVNPTl9VTkRPEAM=');

@$core.Deprecated('Use taskDescriptor instead')
const Task$json = {
  '1': 'Task',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.lasttask.sync.v1.TaskStatus',
      '10': 'status'
    },
    {
      '1': 'created_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {
      '1': 'completed_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'completedAt',
      '17': true
    },
    {'1': 'daily', '3': 7, '4': 1, '5': 8, '10': 'daily'},
    {
      '1': 'tags',
      '3': 8,
      '4': 3,
      '5': 14,
      '6': '.lasttask.sync.v1.TaskTag',
      '10': 'tags'
    },
    {
      '1': 'parent_id',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'parentId',
      '17': true
    },
    {
      '1': 'completion_events',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.CompletionEvent',
      '10': 'completionEvents'
    },
  ],
  '8': [
    {'1': '_completed_at'},
    {'1': '_parent_id'},
  ],
};

/// Descriptor for `Task`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskDescriptor = $convert.base64Decode(
    'CgRUYXNrEg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSNAoGc3RhdHVzGA'
    'MgASgOMhwubGFzdHRhc2suc3luYy52MS5UYXNrU3RhdHVzUgZzdGF0dXMSOQoKY3JlYXRlZF9h'
    'dBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdG'
    'VkX2F0GAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EkIKDGNv'
    'bXBsZXRlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBIAFILY29tcGxldG'
    'VkQXSIAQESFAoFZGFpbHkYByABKAhSBWRhaWx5Ei0KBHRhZ3MYCCADKA4yGS5sYXN0dGFzay5z'
    'eW5jLnYxLlRhc2tUYWdSBHRhZ3MSIAoJcGFyZW50X2lkGAkgASgJSAFSCHBhcmVudElkiAEBEk'
    '4KEWNvbXBsZXRpb25fZXZlbnRzGAogAygLMiEubGFzdHRhc2suc3luYy52MS5Db21wbGV0aW9u'
    'RXZlbnRSEGNvbXBsZXRpb25FdmVudHNCDwoNX2NvbXBsZXRlZF9hdEIMCgpfcGFyZW50X2lk');

@$core.Deprecated('Use completionEventDescriptor instead')
const CompletionEvent$json = {
  '1': 'CompletionEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'occurred_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'logical_date', '3': 3, '4': 1, '5': 9, '10': 'logicalDate'},
  ],
};

/// Descriptor for `CompletionEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completionEventDescriptor = $convert.base64Decode(
    'Cg9Db21wbGV0aW9uRXZlbnQSDgoCaWQYASABKAlSAmlkEjsKC29jY3VycmVkX2F0GAIgASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdBIhCgxsb2dpY2FsX2RhdGUY'
    'AyABKAlSC2xvZ2ljYWxEYXRl');

@$core.Deprecated('Use taskListDescriptor instead')
const TaskList$json = {
  '1': 'TaskList',
  '2': [
    {'1': 'schema_version', '3': 1, '4': 1, '5': 5, '10': 'schemaVersion'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'created_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'habit', '3': 5, '4': 1, '5': 8, '10': 'habit'},
    {'1': 'tutorial', '3': 6, '4': 1, '5': 8, '10': 'tutorial'},
    {'1': 'version', '3': 7, '4': 1, '5': 3, '10': 'version'},
    {
      '1': 'tasks',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.Task',
      '10': 'tasks'
    },
  ],
};

/// Descriptor for `TaskList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskListDescriptor = $convert.base64Decode(
    'CghUYXNrTGlzdBIlCg5zY2hlbWFfdmVyc2lvbhgBIAEoBVINc2NoZW1hVmVyc2lvbhIOCgJpZB'
    'gCIAEoCVICaWQSEgoEbmFtZRgDIAEoCVIEbmFtZRI5CgpjcmVhdGVkX2F0GAQgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EhQKBWhhYml0GAUgASgIUgVoYWJpdB'
    'IaCgh0dXRvcmlhbBgGIAEoCFIIdHV0b3JpYWwSGAoHdmVyc2lvbhgHIAEoA1IHdmVyc2lvbhIs'
    'CgV0YXNrcxgIIAMoCzIWLmxhc3R0YXNrLnN5bmMudjEuVGFza1IFdGFza3M=');

@$core.Deprecated('Use resourceVersionDescriptor instead')
const ResourceVersion$json = {
  '1': 'ResourceVersion',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'version', '3': 2, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `ResourceVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resourceVersionDescriptor = $convert.base64Decode(
    'Cg9SZXNvdXJjZVZlcnNpb24SFwoHbGlzdF9pZBgBIAEoCVIGbGlzdElkEhgKB3ZlcnNpb24YAi'
    'ABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use createListDescriptor instead')
const CreateList$json = {
  '1': 'CreateList',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'created_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'habit', '3': 4, '4': 1, '5': 8, '10': 'habit'},
    {'1': 'tutorial', '3': 5, '4': 1, '5': 8, '10': 'tutorial'},
    {
      '1': 'after_list_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'afterListId',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_list_id'},
  ],
};

/// Descriptor for `CreateList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createListDescriptor = $convert.base64Decode(
    'CgpDcmVhdGVMaXN0EhcKB2xpc3RfaWQYASABKAlSBmxpc3RJZBISCgRuYW1lGAIgASgJUgRuYW'
    '1lEjkKCmNyZWF0ZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVh'
    'dGVkQXQSFAoFaGFiaXQYBCABKAhSBWhhYml0EhoKCHR1dG9yaWFsGAUgASgIUgh0dXRvcmlhbB'
    'InCg1hZnRlcl9saXN0X2lkGAYgASgJSABSC2FmdGVyTGlzdElkiAEBQhAKDl9hZnRlcl9saXN0'
    'X2lk');

@$core.Deprecated('Use renameListDescriptor instead')
const RenameList$json = {
  '1': 'RenameList',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RenameList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameListDescriptor = $convert.base64Decode(
    'CgpSZW5hbWVMaXN0EhcKB2xpc3RfaWQYASABKAlSBmxpc3RJZBISCgRuYW1lGAIgASgJUgRuYW'
    '1l');

@$core.Deprecated('Use deleteListDescriptor instead')
const DeleteList$json = {
  '1': 'DeleteList',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
  ],
};

/// Descriptor for `DeleteList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteListDescriptor = $convert
    .base64Decode('CgpEZWxldGVMaXN0EhcKB2xpc3RfaWQYASABKAlSBmxpc3RJZA==');

@$core.Deprecated('Use restoreListDescriptor instead')
const RestoreList$json = {
  '1': 'RestoreList',
  '2': [
    {
      '1': 'list',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.TaskList',
      '10': 'list'
    },
    {
      '1': 'after_list_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'afterListId',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_list_id'},
  ],
};

/// Descriptor for `RestoreList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restoreListDescriptor = $convert.base64Decode(
    'CgtSZXN0b3JlTGlzdBIuCgRsaXN0GAEgASgLMhoubGFzdHRhc2suc3luYy52MS5UYXNrTGlzdF'
    'IEbGlzdBInCg1hZnRlcl9saXN0X2lkGAIgASgJSABSC2FmdGVyTGlzdElkiAEBQhAKDl9hZnRl'
    'cl9saXN0X2lk');

@$core.Deprecated('Use moveListDescriptor instead')
const MoveList$json = {
  '1': 'MoveList',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {
      '1': 'after_list_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'afterListId',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_list_id'},
  ],
};

/// Descriptor for `MoveList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveListDescriptor = $convert.base64Decode(
    'CghNb3ZlTGlzdBIXCgdsaXN0X2lkGAEgASgJUgZsaXN0SWQSJwoNYWZ0ZXJfbGlzdF9pZBgCIA'
    'EoCUgAUgthZnRlckxpc3RJZIgBAUIQCg5fYWZ0ZXJfbGlzdF9pZA==');

@$core.Deprecated('Use createTaskDescriptor instead')
const CreateTask$json = {
  '1': 'CreateTask',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {
      '1': 'task',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.Task',
      '10': 'task'
    },
    {
      '1': 'after_task_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'afterTaskId',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_task_id'},
  ],
};

/// Descriptor for `CreateTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskDescriptor = $convert.base64Decode(
    'CgpDcmVhdGVUYXNrEhcKB2xpc3RfaWQYASABKAlSBmxpc3RJZBIqCgR0YXNrGAIgASgLMhYubG'
    'FzdHRhc2suc3luYy52MS5UYXNrUgR0YXNrEicKDWFmdGVyX3Rhc2tfaWQYAyABKAlIAFILYWZ0'
    'ZXJUYXNrSWSIAQFCEAoOX2FmdGVyX3Rhc2tfaWQ=');

@$core.Deprecated('Use updateTaskDescriptor instead')
const UpdateTask$json = {
  '1': 'UpdateTask',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {
      '1': 'task',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.Task',
      '10': 'task'
    },
    {
      '1': 'update_mask',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '10': 'updateMask'
    },
  ],
};

/// Descriptor for `UpdateTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTaskDescriptor = $convert.base64Decode(
    'CgpVcGRhdGVUYXNrEhcKB2xpc3RfaWQYASABKAlSBmxpc3RJZBIqCgR0YXNrGAIgASgLMhYubG'
    'FzdHRhc2suc3luYy52MS5UYXNrUgR0YXNrEjsKC3VwZGF0ZV9tYXNrGAMgASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLkZpZWxkTWFza1IKdXBkYXRlTWFzaw==');

@$core.Deprecated('Use deleteTaskDescriptor instead')
const DeleteTask$json = {
  '1': 'DeleteTask',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'task_id', '3': 2, '4': 1, '5': 9, '10': 'taskId'},
  ],
};

/// Descriptor for `DeleteTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTaskDescriptor = $convert.base64Decode(
    'CgpEZWxldGVUYXNrEhcKB2xpc3RfaWQYASABKAlSBmxpc3RJZBIXCgd0YXNrX2lkGAIgASgJUg'
    'Z0YXNrSWQ=');

@$core.Deprecated('Use restoreTaskSubtreeDescriptor instead')
const RestoreTaskSubtree$json = {
  '1': 'RestoreTaskSubtree',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {
      '1': 'tasks',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.Task',
      '10': 'tasks'
    },
    {
      '1': 'after_task_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'afterTaskId',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_task_id'},
  ],
};

/// Descriptor for `RestoreTaskSubtree`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restoreTaskSubtreeDescriptor = $convert.base64Decode(
    'ChJSZXN0b3JlVGFza1N1YnRyZWUSFwoHbGlzdF9pZBgBIAEoCVIGbGlzdElkEiwKBXRhc2tzGA'
    'IgAygLMhYubGFzdHRhc2suc3luYy52MS5UYXNrUgV0YXNrcxInCg1hZnRlcl90YXNrX2lkGAMg'
    'ASgJSABSC2FmdGVyVGFza0lkiAEBQhAKDl9hZnRlcl90YXNrX2lk');

@$core.Deprecated('Use moveTaskDescriptor instead')
const MoveTask$json = {
  '1': 'MoveTask',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'task_id', '3': 2, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'parent_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'parentId',
      '17': true
    },
    {
      '1': 'after_task_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'afterTaskId',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent_id'},
    {'1': '_after_task_id'},
  ],
};

/// Descriptor for `MoveTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveTaskDescriptor = $convert.base64Decode(
    'CghNb3ZlVGFzaxIXCgdsaXN0X2lkGAEgASgJUgZsaXN0SWQSFwoHdGFza19pZBgCIAEoCVIGdG'
    'Fza0lkEiAKCXBhcmVudF9pZBgDIAEoCUgAUghwYXJlbnRJZIgBARInCg1hZnRlcl90YXNrX2lk'
    'GAQgASgJSAFSC2FmdGVyVGFza0lkiAEBQgwKCl9wYXJlbnRfaWRCEAoOX2FmdGVyX3Rhc2tfaW'
    'Q=');

@$core.Deprecated('Use setTaskStatusDescriptor instead')
const SetTaskStatus$json = {
  '1': 'SetTaskStatus',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'task_id', '3': 2, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.lasttask.sync.v1.TaskStatus',
      '10': 'status'
    },
    {
      '1': 'include_descendants',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'includeDescendants'
    },
    {
      '1': 'changed_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'changedAt'
    },
    {
      '1': 'reason',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.lasttask.sync.v1.StatusChangeReason',
      '10': 'reason'
    },
  ],
};

/// Descriptor for `SetTaskStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setTaskStatusDescriptor = $convert.base64Decode(
    'Cg1TZXRUYXNrU3RhdHVzEhcKB2xpc3RfaWQYASABKAlSBmxpc3RJZBIXCgd0YXNrX2lkGAIgAS'
    'gJUgZ0YXNrSWQSNAoGc3RhdHVzGAMgASgOMhwubGFzdHRhc2suc3luYy52MS5UYXNrU3RhdHVz'
    'UgZzdGF0dXMSLwoTaW5jbHVkZV9kZXNjZW5kYW50cxgEIAEoCFISaW5jbHVkZURlc2NlbmRhbn'
    'RzEjkKCmNoYW5nZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljaGFu'
    'Z2VkQXQSPAoGcmVhc29uGAYgASgOMiQubGFzdHRhc2suc3luYy52MS5TdGF0dXNDaGFuZ2VSZW'
    'Fzb25SBnJlYXNvbg==');

@$core.Deprecated('Use addCompletionEventDescriptor instead')
const AddCompletionEvent$json = {
  '1': 'AddCompletionEvent',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'task_id', '3': 2, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'event',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.CompletionEvent',
      '10': 'event'
    },
  ],
};

/// Descriptor for `AddCompletionEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addCompletionEventDescriptor = $convert.base64Decode(
    'ChJBZGRDb21wbGV0aW9uRXZlbnQSFwoHbGlzdF9pZBgBIAEoCVIGbGlzdElkEhcKB3Rhc2tfaW'
    'QYAiABKAlSBnRhc2tJZBI3CgVldmVudBgDIAEoCzIhLmxhc3R0YXNrLnN5bmMudjEuQ29tcGxl'
    'dGlvbkV2ZW50UgVldmVudA==');

@$core.Deprecated('Use removeCompletionEventDescriptor instead')
const RemoveCompletionEvent$json = {
  '1': 'RemoveCompletionEvent',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'task_id', '3': 2, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'event_id', '3': 3, '4': 1, '5': 9, '10': 'eventId'},
  ],
};

/// Descriptor for `RemoveCompletionEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeCompletionEventDescriptor = $convert.base64Decode(
    'ChVSZW1vdmVDb21wbGV0aW9uRXZlbnQSFwoHbGlzdF9pZBgBIAEoCVIGbGlzdElkEhcKB3Rhc2'
    'tfaWQYAiABKAlSBnRhc2tJZBIZCghldmVudF9pZBgDIAEoCVIHZXZlbnRJZA==');

@$core.Deprecated('Use resetDailyTaskDescriptor instead')
const ResetDailyTask$json = {
  '1': 'ResetDailyTask',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'task_id', '3': 2, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'logical_date', '3': 3, '4': 1, '5': 9, '10': 'logicalDate'},
    {
      '1': 'changed_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'changedAt'
    },
  ],
};

/// Descriptor for `ResetDailyTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetDailyTaskDescriptor = $convert.base64Decode(
    'Cg5SZXNldERhaWx5VGFzaxIXCgdsaXN0X2lkGAEgASgJUgZsaXN0SWQSFwoHdGFza19pZBgCIA'
    'EoCVIGdGFza0lkEiEKDGxvZ2ljYWxfZGF0ZRgDIAEoCVILbG9naWNhbERhdGUSOQoKY2hhbmdl'
    'ZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNoYW5nZWRBdA==');

@$core.Deprecated('Use operationDescriptor instead')
const Operation$json = {
  '1': 'Operation',
  '2': [
    {
      '1': 'create_list',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.CreateList',
      '9': 0,
      '10': 'createList'
    },
    {
      '1': 'rename_list',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.RenameList',
      '9': 0,
      '10': 'renameList'
    },
    {
      '1': 'delete_list',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.DeleteList',
      '9': 0,
      '10': 'deleteList'
    },
    {
      '1': 'restore_list',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.RestoreList',
      '9': 0,
      '10': 'restoreList'
    },
    {
      '1': 'move_list',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.MoveList',
      '9': 0,
      '10': 'moveList'
    },
    {
      '1': 'create_task',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.CreateTask',
      '9': 0,
      '10': 'createTask'
    },
    {
      '1': 'update_task',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.UpdateTask',
      '9': 0,
      '10': 'updateTask'
    },
    {
      '1': 'delete_task',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.DeleteTask',
      '9': 0,
      '10': 'deleteTask'
    },
    {
      '1': 'restore_task_subtree',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.RestoreTaskSubtree',
      '9': 0,
      '10': 'restoreTaskSubtree'
    },
    {
      '1': 'move_task',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.MoveTask',
      '9': 0,
      '10': 'moveTask'
    },
    {
      '1': 'set_task_status',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.SetTaskStatus',
      '9': 0,
      '10': 'setTaskStatus'
    },
    {
      '1': 'add_completion_event',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.AddCompletionEvent',
      '9': 0,
      '10': 'addCompletionEvent'
    },
    {
      '1': 'remove_completion_event',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.RemoveCompletionEvent',
      '9': 0,
      '10': 'removeCompletionEvent'
    },
    {
      '1': 'reset_daily_task',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.ResetDailyTask',
      '9': 0,
      '10': 'resetDailyTask'
    },
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `Operation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationDescriptor = $convert.base64Decode(
    'CglPcGVyYXRpb24SPwoLY3JlYXRlX2xpc3QYASABKAsyHC5sYXN0dGFzay5zeW5jLnYxLkNyZW'
    'F0ZUxpc3RIAFIKY3JlYXRlTGlzdBI/CgtyZW5hbWVfbGlzdBgCIAEoCzIcLmxhc3R0YXNrLnN5'
    'bmMudjEuUmVuYW1lTGlzdEgAUgpyZW5hbWVMaXN0Ej8KC2RlbGV0ZV9saXN0GAMgASgLMhwubG'
    'FzdHRhc2suc3luYy52MS5EZWxldGVMaXN0SABSCmRlbGV0ZUxpc3QSQgoMcmVzdG9yZV9saXN0'
    'GAQgASgLMh0ubGFzdHRhc2suc3luYy52MS5SZXN0b3JlTGlzdEgAUgtyZXN0b3JlTGlzdBI5Cg'
    'ltb3ZlX2xpc3QYBSABKAsyGi5sYXN0dGFzay5zeW5jLnYxLk1vdmVMaXN0SABSCG1vdmVMaXN0'
    'Ej8KC2NyZWF0ZV90YXNrGAYgASgLMhwubGFzdHRhc2suc3luYy52MS5DcmVhdGVUYXNrSABSCm'
    'NyZWF0ZVRhc2sSPwoLdXBkYXRlX3Rhc2sYByABKAsyHC5sYXN0dGFzay5zeW5jLnYxLlVwZGF0'
    'ZVRhc2tIAFIKdXBkYXRlVGFzaxI/CgtkZWxldGVfdGFzaxgIIAEoCzIcLmxhc3R0YXNrLnN5bm'
    'MudjEuRGVsZXRlVGFza0gAUgpkZWxldGVUYXNrElgKFHJlc3RvcmVfdGFza19zdWJ0cmVlGAkg'
    'ASgLMiQubGFzdHRhc2suc3luYy52MS5SZXN0b3JlVGFza1N1YnRyZWVIAFIScmVzdG9yZVRhc2'
    'tTdWJ0cmVlEjkKCW1vdmVfdGFzaxgKIAEoCzIaLmxhc3R0YXNrLnN5bmMudjEuTW92ZVRhc2tI'
    'AFIIbW92ZVRhc2sSSQoPc2V0X3Rhc2tfc3RhdHVzGAsgASgLMh8ubGFzdHRhc2suc3luYy52MS'
    '5TZXRUYXNrU3RhdHVzSABSDXNldFRhc2tTdGF0dXMSWAoUYWRkX2NvbXBsZXRpb25fZXZlbnQY'
    'DCABKAsyJC5sYXN0dGFzay5zeW5jLnYxLkFkZENvbXBsZXRpb25FdmVudEgAUhJhZGRDb21wbG'
    'V0aW9uRXZlbnQSYQoXcmVtb3ZlX2NvbXBsZXRpb25fZXZlbnQYDSABKAsyJy5sYXN0dGFzay5z'
    'eW5jLnYxLlJlbW92ZUNvbXBsZXRpb25FdmVudEgAUhVyZW1vdmVDb21wbGV0aW9uRXZlbnQSTA'
    'oQcmVzZXRfZGFpbHlfdGFzaxgOIAEoCzIgLmxhc3R0YXNrLnN5bmMudjEuUmVzZXREYWlseVRh'
    'c2tIAFIOcmVzZXREYWlseVRhc2tCBwoFdmFsdWU=');

@$core.Deprecated('Use workspaceMutationDescriptor instead')
const WorkspaceMutation$json = {
  '1': 'WorkspaceMutation',
  '2': [
    {'1': 'mutation_id', '3': 1, '4': 1, '5': 9, '10': 'mutationId'},
    {'1': 'device_id', '3': 2, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'base_workspace_revision',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'baseWorkspaceRevision'
    },
    {
      '1': 'base_list_versions',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.ResourceVersion',
      '10': 'baseListVersions'
    },
    {
      '1': 'created_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'operations',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.Operation',
      '10': 'operations'
    },
  ],
};

/// Descriptor for `WorkspaceMutation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workspaceMutationDescriptor = $convert.base64Decode(
    'ChFXb3Jrc3BhY2VNdXRhdGlvbhIfCgttdXRhdGlvbl9pZBgBIAEoCVIKbXV0YXRpb25JZBIbCg'
    'lkZXZpY2VfaWQYAiABKAlSCGRldmljZUlkEjYKF2Jhc2Vfd29ya3NwYWNlX3JldmlzaW9uGAMg'
    'ASgDUhViYXNlV29ya3NwYWNlUmV2aXNpb24STwoSYmFzZV9saXN0X3ZlcnNpb25zGAQgAygLMi'
    'EubGFzdHRhc2suc3luYy52MS5SZXNvdXJjZVZlcnNpb25SEGJhc2VMaXN0VmVyc2lvbnMSOQoK'
    'Y3JlYXRlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdB'
    'I7CgpvcGVyYXRpb25zGAYgAygLMhsubGFzdHRhc2suc3luYy52MS5PcGVyYXRpb25SCm9wZXJh'
    'dGlvbnM=');

@$core.Deprecated('Use mutationResultDescriptor instead')
const MutationResult$json = {
  '1': 'MutationResult',
  '2': [
    {'1': 'mutation_id', '3': 1, '4': 1, '5': 9, '10': 'mutationId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.lasttask.sync.v1.MutationResultStatus',
      '10': 'status'
    },
    {
      '1': 'workspace_revision',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'workspaceRevision'
    },
    {
      '1': 'list_versions',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.ResourceVersion',
      '10': 'listVersions'
    },
    {
      '1': 'changed_lists',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.TaskList',
      '10': 'changedLists'
    },
    {'1': 'deleted_list_ids', '3': 6, '4': 3, '5': 9, '10': 'deletedListIds'},
    {'1': 'message', '3': 7, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `MutationResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mutationResultDescriptor = $convert.base64Decode(
    'Cg5NdXRhdGlvblJlc3VsdBIfCgttdXRhdGlvbl9pZBgBIAEoCVIKbXV0YXRpb25JZBI+CgZzdG'
    'F0dXMYAiABKA4yJi5sYXN0dGFzay5zeW5jLnYxLk11dGF0aW9uUmVzdWx0U3RhdHVzUgZzdGF0'
    'dXMSLQoSd29ya3NwYWNlX3JldmlzaW9uGAMgASgDUhF3b3Jrc3BhY2VSZXZpc2lvbhJGCg1saX'
    'N0X3ZlcnNpb25zGAQgAygLMiEubGFzdHRhc2suc3luYy52MS5SZXNvdXJjZVZlcnNpb25SDGxp'
    'c3RWZXJzaW9ucxI/Cg1jaGFuZ2VkX2xpc3RzGAUgAygLMhoubGFzdHRhc2suc3luYy52MS5UYX'
    'NrTGlzdFIMY2hhbmdlZExpc3RzEigKEGRlbGV0ZWRfbGlzdF9pZHMYBiADKAlSDmRlbGV0ZWRM'
    'aXN0SWRzEhgKB21lc3NhZ2UYByABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use workspaceSnapshotDescriptor instead')
const WorkspaceSnapshot$json = {
  '1': 'WorkspaceSnapshot',
  '2': [
    {
      '1': 'workspace_revision',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'workspaceRevision'
    },
    {
      '1': 'history_floor_revision',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'historyFloorRevision'
    },
    {'1': 'account_timezone', '3': 3, '4': 1, '5': 9, '10': 'accountTimezone'},
    {
      '1': 'lists',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.TaskList',
      '10': 'lists'
    },
  ],
};

/// Descriptor for `WorkspaceSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workspaceSnapshotDescriptor = $convert.base64Decode(
    'ChFXb3Jrc3BhY2VTbmFwc2hvdBItChJ3b3Jrc3BhY2VfcmV2aXNpb24YASABKANSEXdvcmtzcG'
    'FjZVJldmlzaW9uEjQKFmhpc3RvcnlfZmxvb3JfcmV2aXNpb24YAiABKANSFGhpc3RvcnlGbG9v'
    'clJldmlzaW9uEikKEGFjY291bnRfdGltZXpvbmUYAyABKAlSD2FjY291bnRUaW1lem9uZRIwCg'
    'VsaXN0cxgEIAMoCzIaLmxhc3R0YXNrLnN5bmMudjEuVGFza0xpc3RSBWxpc3Rz');

@$core.Deprecated('Use getSnapshotRequestDescriptor instead')
const GetSnapshotRequest$json = {
  '1': 'GetSnapshotRequest',
};

/// Descriptor for `GetSnapshotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSnapshotRequestDescriptor =
    $convert.base64Decode('ChJHZXRTbmFwc2hvdFJlcXVlc3Q=');

@$core.Deprecated('Use getSnapshotResponseDescriptor instead')
const GetSnapshotResponse$json = {
  '1': 'GetSnapshotResponse',
  '2': [
    {
      '1': 'snapshot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.WorkspaceSnapshot',
      '10': 'snapshot'
    },
  ],
};

/// Descriptor for `GetSnapshotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSnapshotResponseDescriptor = $convert.base64Decode(
    'ChNHZXRTbmFwc2hvdFJlc3BvbnNlEj8KCHNuYXBzaG90GAEgASgLMiMubGFzdHRhc2suc3luYy'
    '52MS5Xb3Jrc3BhY2VTbmFwc2hvdFIIc25hcHNob3Q=');

@$core.Deprecated('Use pullChangesRequestDescriptor instead')
const PullChangesRequest$json = {
  '1': 'PullChangesRequest',
  '2': [
    {'1': 'after_revision', '3': 1, '4': 1, '5': 3, '10': 'afterRevision'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `PullChangesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullChangesRequestDescriptor = $convert.base64Decode(
    'ChJQdWxsQ2hhbmdlc1JlcXVlc3QSJQoOYWZ0ZXJfcmV2aXNpb24YASABKANSDWFmdGVyUmV2aX'
    'Npb24SFAoFbGltaXQYAiABKAVSBWxpbWl0');

@$core.Deprecated('Use workspaceChangeDescriptor instead')
const WorkspaceChange$json = {
  '1': 'WorkspaceChange',
  '2': [
    {
      '1': 'workspace_revision',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'workspaceRevision'
    },
    {
      '1': 'mutation',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.WorkspaceMutation',
      '10': 'mutation'
    },
    {
      '1': 'result',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.lasttask.sync.v1.MutationResult',
      '10': 'result'
    },
  ],
};

/// Descriptor for `WorkspaceChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workspaceChangeDescriptor = $convert.base64Decode(
    'Cg9Xb3Jrc3BhY2VDaGFuZ2USLQoSd29ya3NwYWNlX3JldmlzaW9uGAEgASgDUhF3b3Jrc3BhY2'
    'VSZXZpc2lvbhI/CghtdXRhdGlvbhgCIAEoCzIjLmxhc3R0YXNrLnN5bmMudjEuV29ya3NwYWNl'
    'TXV0YXRpb25SCG11dGF0aW9uEjgKBnJlc3VsdBgDIAEoCzIgLmxhc3R0YXNrLnN5bmMudjEuTX'
    'V0YXRpb25SZXN1bHRSBnJlc3VsdA==');

@$core.Deprecated('Use pullChangesResponseDescriptor instead')
const PullChangesResponse$json = {
  '1': 'PullChangesResponse',
  '2': [
    {'1': 'current_revision', '3': 1, '4': 1, '5': 3, '10': 'currentRevision'},
    {
      '1': 'history_floor_revision',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'historyFloorRevision'
    },
    {'1': 'reset_required', '3': 3, '4': 1, '5': 8, '10': 'resetRequired'},
    {
      '1': 'changes',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.WorkspaceChange',
      '10': 'changes'
    },
  ],
};

/// Descriptor for `PullChangesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullChangesResponseDescriptor = $convert.base64Decode(
    'ChNQdWxsQ2hhbmdlc1Jlc3BvbnNlEikKEGN1cnJlbnRfcmV2aXNpb24YASABKANSD2N1cnJlbn'
    'RSZXZpc2lvbhI0ChZoaXN0b3J5X2Zsb29yX3JldmlzaW9uGAIgASgDUhRoaXN0b3J5Rmxvb3JS'
    'ZXZpc2lvbhIlCg5yZXNldF9yZXF1aXJlZBgDIAEoCFINcmVzZXRSZXF1aXJlZBI7CgdjaGFuZ2'
    'VzGAQgAygLMiEubGFzdHRhc2suc3luYy52MS5Xb3Jrc3BhY2VDaGFuZ2VSB2NoYW5nZXM=');

@$core.Deprecated('Use pushMutationsRequestDescriptor instead')
const PushMutationsRequest$json = {
  '1': 'PushMutationsRequest',
  '2': [
    {
      '1': 'mutations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.WorkspaceMutation',
      '10': 'mutations'
    },
  ],
};

/// Descriptor for `PushMutationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushMutationsRequestDescriptor = $convert.base64Decode(
    'ChRQdXNoTXV0YXRpb25zUmVxdWVzdBJBCgltdXRhdGlvbnMYASADKAsyIy5sYXN0dGFzay5zeW'
    '5jLnYxLldvcmtzcGFjZU11dGF0aW9uUgltdXRhdGlvbnM=');

@$core.Deprecated('Use pushMutationsResponseDescriptor instead')
const PushMutationsResponse$json = {
  '1': 'PushMutationsResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.lasttask.sync.v1.MutationResult',
      '10': 'results'
    },
  ],
};

/// Descriptor for `PushMutationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushMutationsResponseDescriptor = $convert.base64Decode(
    'ChVQdXNoTXV0YXRpb25zUmVzcG9uc2USOgoHcmVzdWx0cxgBIAMoCzIgLmxhc3R0YXNrLnN5bm'
    'MudjEuTXV0YXRpb25SZXN1bHRSB3Jlc3VsdHM=');

@$core.Deprecated('Use updateWorkspaceSettingsRequestDescriptor instead')
const UpdateWorkspaceSettingsRequest$json = {
  '1': 'UpdateWorkspaceSettingsRequest',
  '2': [
    {'1': 'account_timezone', '3': 1, '4': 1, '5': 9, '10': 'accountTimezone'},
  ],
};

/// Descriptor for `UpdateWorkspaceSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateWorkspaceSettingsRequestDescriptor =
    $convert.base64Decode(
        'Ch5VcGRhdGVXb3Jrc3BhY2VTZXR0aW5nc1JlcXVlc3QSKQoQYWNjb3VudF90aW1lem9uZRgBIA'
        'EoCVIPYWNjb3VudFRpbWV6b25l');

@$core.Deprecated('Use updateWorkspaceSettingsResponseDescriptor instead')
const UpdateWorkspaceSettingsResponse$json = {
  '1': 'UpdateWorkspaceSettingsResponse',
  '2': [
    {
      '1': 'workspace_revision',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'workspaceRevision'
    },
    {'1': 'account_timezone', '3': 2, '4': 1, '5': 9, '10': 'accountTimezone'},
  ],
};

/// Descriptor for `UpdateWorkspaceSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateWorkspaceSettingsResponseDescriptor =
    $convert.base64Decode(
        'Ch9VcGRhdGVXb3Jrc3BhY2VTZXR0aW5nc1Jlc3BvbnNlEi0KEndvcmtzcGFjZV9yZXZpc2lvbh'
        'gBIAEoA1IRd29ya3NwYWNlUmV2aXNpb24SKQoQYWNjb3VudF90aW1lem9uZRgCIAEoCVIPYWNj'
        'b3VudFRpbWV6b25l');

@$core.Deprecated('Use watchWorkspaceRequestDescriptor instead')
const WatchWorkspaceRequest$json = {
  '1': 'WatchWorkspaceRequest',
  '2': [
    {'1': 'after_revision', '3': 1, '4': 1, '5': 3, '10': 'afterRevision'},
  ],
};

/// Descriptor for `WatchWorkspaceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchWorkspaceRequestDescriptor = $convert.base64Decode(
    'ChVXYXRjaFdvcmtzcGFjZVJlcXVlc3QSJQoOYWZ0ZXJfcmV2aXNpb24YASABKANSDWFmdGVyUm'
    'V2aXNpb24=');

@$core.Deprecated('Use watchWorkspaceResponseDescriptor instead')
const WatchWorkspaceResponse$json = {
  '1': 'WatchWorkspaceResponse',
  '2': [
    {
      '1': 'workspace_revision',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'workspaceRevision'
    },
  ],
};

/// Descriptor for `WatchWorkspaceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchWorkspaceResponseDescriptor =
    $convert.base64Decode(
        'ChZXYXRjaFdvcmtzcGFjZVJlc3BvbnNlEi0KEndvcmtzcGFjZV9yZXZpc2lvbhgBIAEoA1IRd2'
        '9ya3NwYWNlUmV2aXNpb24=');

@$core.Deprecated('Use pingRequestDescriptor instead')
const PingRequest$json = {
  '1': 'PingRequest',
};

/// Descriptor for `PingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingRequestDescriptor =
    $convert.base64Decode('CgtQaW5nUmVxdWVzdA==');

@$core.Deprecated('Use pingResponseDescriptor instead')
const PingResponse$json = {
  '1': 'PingResponse',
};

/// Descriptor for `PingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingResponseDescriptor =
    $convert.base64Decode('CgxQaW5nUmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> WorkspaceSyncServiceBase$json = {
  '1': 'WorkspaceSyncService',
  '2': [
    {
      '1': 'GetSnapshot',
      '2': '.lasttask.sync.v1.GetSnapshotRequest',
      '3': '.lasttask.sync.v1.GetSnapshotResponse'
    },
    {
      '1': 'PullChanges',
      '2': '.lasttask.sync.v1.PullChangesRequest',
      '3': '.lasttask.sync.v1.PullChangesResponse'
    },
    {
      '1': 'PushMutations',
      '2': '.lasttask.sync.v1.PushMutationsRequest',
      '3': '.lasttask.sync.v1.PushMutationsResponse'
    },
    {
      '1': 'UpdateWorkspaceSettings',
      '2': '.lasttask.sync.v1.UpdateWorkspaceSettingsRequest',
      '3': '.lasttask.sync.v1.UpdateWorkspaceSettingsResponse'
    },
    {
      '1': 'WatchWorkspace',
      '2': '.lasttask.sync.v1.WatchWorkspaceRequest',
      '3': '.lasttask.sync.v1.WatchWorkspaceResponse',
      '6': true
    },
    {
      '1': 'Ping',
      '2': '.lasttask.sync.v1.PingRequest',
      '3': '.lasttask.sync.v1.PingResponse'
    },
  ],
};

@$core.Deprecated('Use workspaceSyncServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    WorkspaceSyncServiceBase$messageJson = {
  '.lasttask.sync.v1.GetSnapshotRequest': GetSnapshotRequest$json,
  '.lasttask.sync.v1.GetSnapshotResponse': GetSnapshotResponse$json,
  '.lasttask.sync.v1.WorkspaceSnapshot': WorkspaceSnapshot$json,
  '.lasttask.sync.v1.TaskList': TaskList$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.lasttask.sync.v1.Task': Task$json,
  '.lasttask.sync.v1.CompletionEvent': CompletionEvent$json,
  '.lasttask.sync.v1.PullChangesRequest': PullChangesRequest$json,
  '.lasttask.sync.v1.PullChangesResponse': PullChangesResponse$json,
  '.lasttask.sync.v1.WorkspaceChange': WorkspaceChange$json,
  '.lasttask.sync.v1.WorkspaceMutation': WorkspaceMutation$json,
  '.lasttask.sync.v1.ResourceVersion': ResourceVersion$json,
  '.lasttask.sync.v1.Operation': Operation$json,
  '.lasttask.sync.v1.CreateList': CreateList$json,
  '.lasttask.sync.v1.RenameList': RenameList$json,
  '.lasttask.sync.v1.DeleteList': DeleteList$json,
  '.lasttask.sync.v1.RestoreList': RestoreList$json,
  '.lasttask.sync.v1.MoveList': MoveList$json,
  '.lasttask.sync.v1.CreateTask': CreateTask$json,
  '.lasttask.sync.v1.UpdateTask': UpdateTask$json,
  '.google.protobuf.FieldMask': $1.FieldMask$json,
  '.lasttask.sync.v1.DeleteTask': DeleteTask$json,
  '.lasttask.sync.v1.RestoreTaskSubtree': RestoreTaskSubtree$json,
  '.lasttask.sync.v1.MoveTask': MoveTask$json,
  '.lasttask.sync.v1.SetTaskStatus': SetTaskStatus$json,
  '.lasttask.sync.v1.AddCompletionEvent': AddCompletionEvent$json,
  '.lasttask.sync.v1.RemoveCompletionEvent': RemoveCompletionEvent$json,
  '.lasttask.sync.v1.ResetDailyTask': ResetDailyTask$json,
  '.lasttask.sync.v1.MutationResult': MutationResult$json,
  '.lasttask.sync.v1.PushMutationsRequest': PushMutationsRequest$json,
  '.lasttask.sync.v1.PushMutationsResponse': PushMutationsResponse$json,
  '.lasttask.sync.v1.UpdateWorkspaceSettingsRequest':
      UpdateWorkspaceSettingsRequest$json,
  '.lasttask.sync.v1.UpdateWorkspaceSettingsResponse':
      UpdateWorkspaceSettingsResponse$json,
  '.lasttask.sync.v1.WatchWorkspaceRequest': WatchWorkspaceRequest$json,
  '.lasttask.sync.v1.WatchWorkspaceResponse': WatchWorkspaceResponse$json,
  '.lasttask.sync.v1.PingRequest': PingRequest$json,
  '.lasttask.sync.v1.PingResponse': PingResponse$json,
};

/// Descriptor for `WorkspaceSyncService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List workspaceSyncServiceDescriptor = $convert.base64Decode(
    'ChRXb3Jrc3BhY2VTeW5jU2VydmljZRJaCgtHZXRTbmFwc2hvdBIkLmxhc3R0YXNrLnN5bmMudj'
    'EuR2V0U25hcHNob3RSZXF1ZXN0GiUubGFzdHRhc2suc3luYy52MS5HZXRTbmFwc2hvdFJlc3Bv'
    'bnNlEloKC1B1bGxDaGFuZ2VzEiQubGFzdHRhc2suc3luYy52MS5QdWxsQ2hhbmdlc1JlcXVlc3'
    'QaJS5sYXN0dGFzay5zeW5jLnYxLlB1bGxDaGFuZ2VzUmVzcG9uc2USYAoNUHVzaE11dGF0aW9u'
    'cxImLmxhc3R0YXNrLnN5bmMudjEuUHVzaE11dGF0aW9uc1JlcXVlc3QaJy5sYXN0dGFzay5zeW'
    '5jLnYxLlB1c2hNdXRhdGlvbnNSZXNwb25zZRJ+ChdVcGRhdGVXb3Jrc3BhY2VTZXR0aW5ncxIw'
    'Lmxhc3R0YXNrLnN5bmMudjEuVXBkYXRlV29ya3NwYWNlU2V0dGluZ3NSZXF1ZXN0GjEubGFzdH'
    'Rhc2suc3luYy52MS5VcGRhdGVXb3Jrc3BhY2VTZXR0aW5nc1Jlc3BvbnNlEmUKDldhdGNoV29y'
    'a3NwYWNlEicubGFzdHRhc2suc3luYy52MS5XYXRjaFdvcmtzcGFjZVJlcXVlc3QaKC5sYXN0dG'
    'Fzay5zeW5jLnYxLldhdGNoV29ya3NwYWNlUmVzcG9uc2UwARJFCgRQaW5nEh0ubGFzdHRhc2su'
    'c3luYy52MS5QaW5nUmVxdWVzdBoeLmxhc3R0YXNrLnN5bmMudjEuUGluZ1Jlc3BvbnNl');
