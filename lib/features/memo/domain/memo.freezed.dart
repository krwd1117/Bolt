// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Memo {

 int get id; String get content; String? get targetDbId; DateTime get createdAt; SyncStatus get status; int get retryCount; String? get notionPageId; bool get isDone; String? get type; DateTime? get dueDate;
/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoCopyWith<Memo> get copyWith => _$MemoCopyWithImpl<Memo>(this as Memo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Memo&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.targetDbId, targetDbId) || other.targetDbId == targetDbId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.notionPageId, notionPageId) || other.notionPageId == notionPageId)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.type, type) || other.type == type)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}


@override
int get hashCode => Object.hash(runtimeType,id,content,targetDbId,createdAt,status,retryCount,notionPageId,isDone,type,dueDate);

@override
String toString() {
  return 'Memo(id: $id, content: $content, targetDbId: $targetDbId, createdAt: $createdAt, status: $status, retryCount: $retryCount, notionPageId: $notionPageId, isDone: $isDone, type: $type, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $MemoCopyWith<$Res>  {
  factory $MemoCopyWith(Memo value, $Res Function(Memo) _then) = _$MemoCopyWithImpl;
@useResult
$Res call({
 int id, String content, String? targetDbId, DateTime createdAt, SyncStatus status, int retryCount, String? notionPageId, bool isDone, String? type, DateTime? dueDate
});




}
/// @nodoc
class _$MemoCopyWithImpl<$Res>
    implements $MemoCopyWith<$Res> {
  _$MemoCopyWithImpl(this._self, this._then);

  final Memo _self;
  final $Res Function(Memo) _then;

/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? targetDbId = freezed,Object? createdAt = null,Object? status = null,Object? retryCount = null,Object? notionPageId = freezed,Object? isDone = null,Object? type = freezed,Object? dueDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,targetDbId: freezed == targetDbId ? _self.targetDbId : targetDbId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,notionPageId: freezed == notionPageId ? _self.notionPageId : notionPageId // ignore: cast_nullable_to_non_nullable
as String?,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Memo].
extension MemoPatterns on Memo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Memo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Memo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Memo value)  $default,){
final _that = this;
switch (_that) {
case _Memo():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Memo value)?  $default,){
final _that = this;
switch (_that) {
case _Memo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String content,  String? targetDbId,  DateTime createdAt,  SyncStatus status,  int retryCount,  String? notionPageId,  bool isDone,  String? type,  DateTime? dueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Memo() when $default != null:
return $default(_that.id,_that.content,_that.targetDbId,_that.createdAt,_that.status,_that.retryCount,_that.notionPageId,_that.isDone,_that.type,_that.dueDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String content,  String? targetDbId,  DateTime createdAt,  SyncStatus status,  int retryCount,  String? notionPageId,  bool isDone,  String? type,  DateTime? dueDate)  $default,) {final _that = this;
switch (_that) {
case _Memo():
return $default(_that.id,_that.content,_that.targetDbId,_that.createdAt,_that.status,_that.retryCount,_that.notionPageId,_that.isDone,_that.type,_that.dueDate);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String content,  String? targetDbId,  DateTime createdAt,  SyncStatus status,  int retryCount,  String? notionPageId,  bool isDone,  String? type,  DateTime? dueDate)?  $default,) {final _that = this;
switch (_that) {
case _Memo() when $default != null:
return $default(_that.id,_that.content,_that.targetDbId,_that.createdAt,_that.status,_that.retryCount,_that.notionPageId,_that.isDone,_that.type,_that.dueDate);case _:
  return null;

}
}

}

/// @nodoc


class _Memo implements Memo {
  const _Memo({required this.id, required this.content, this.targetDbId, required this.createdAt, required this.status, required this.retryCount, this.notionPageId, this.isDone = false, this.type, this.dueDate});
  

@override final  int id;
@override final  String content;
@override final  String? targetDbId;
@override final  DateTime createdAt;
@override final  SyncStatus status;
@override final  int retryCount;
@override final  String? notionPageId;
@override@JsonKey() final  bool isDone;
@override final  String? type;
@override final  DateTime? dueDate;

/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoCopyWith<_Memo> get copyWith => __$MemoCopyWithImpl<_Memo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Memo&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.targetDbId, targetDbId) || other.targetDbId == targetDbId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.notionPageId, notionPageId) || other.notionPageId == notionPageId)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.type, type) || other.type == type)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}


@override
int get hashCode => Object.hash(runtimeType,id,content,targetDbId,createdAt,status,retryCount,notionPageId,isDone,type,dueDate);

@override
String toString() {
  return 'Memo(id: $id, content: $content, targetDbId: $targetDbId, createdAt: $createdAt, status: $status, retryCount: $retryCount, notionPageId: $notionPageId, isDone: $isDone, type: $type, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class _$MemoCopyWith<$Res> implements $MemoCopyWith<$Res> {
  factory _$MemoCopyWith(_Memo value, $Res Function(_Memo) _then) = __$MemoCopyWithImpl;
@override @useResult
$Res call({
 int id, String content, String? targetDbId, DateTime createdAt, SyncStatus status, int retryCount, String? notionPageId, bool isDone, String? type, DateTime? dueDate
});




}
/// @nodoc
class __$MemoCopyWithImpl<$Res>
    implements _$MemoCopyWith<$Res> {
  __$MemoCopyWithImpl(this._self, this._then);

  final _Memo _self;
  final $Res Function(_Memo) _then;

/// Create a copy of Memo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? targetDbId = freezed,Object? createdAt = null,Object? status = null,Object? retryCount = null,Object? notionPageId = freezed,Object? isDone = null,Object? type = freezed,Object? dueDate = freezed,}) {
  return _then(_Memo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,targetDbId: freezed == targetDbId ? _self.targetDbId : targetDbId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,notionPageId: freezed == notionPageId ? _self.notionPageId : notionPageId // ignore: cast_nullable_to_non_nullable
as String?,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
