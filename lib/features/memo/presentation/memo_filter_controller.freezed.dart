// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memo_filter_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MemoFilterState {

 DateFilter get dateFilter; Set<String> get selectedTypes;
/// Create a copy of MemoFilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoFilterStateCopyWith<MemoFilterState> get copyWith => _$MemoFilterStateCopyWithImpl<MemoFilterState>(this as MemoFilterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoFilterState&&(identical(other.dateFilter, dateFilter) || other.dateFilter == dateFilter)&&const DeepCollectionEquality().equals(other.selectedTypes, selectedTypes));
}


@override
int get hashCode => Object.hash(runtimeType,dateFilter,const DeepCollectionEquality().hash(selectedTypes));

@override
String toString() {
  return 'MemoFilterState(dateFilter: $dateFilter, selectedTypes: $selectedTypes)';
}


}

/// @nodoc
abstract mixin class $MemoFilterStateCopyWith<$Res>  {
  factory $MemoFilterStateCopyWith(MemoFilterState value, $Res Function(MemoFilterState) _then) = _$MemoFilterStateCopyWithImpl;
@useResult
$Res call({
 DateFilter dateFilter, Set<String> selectedTypes
});




}
/// @nodoc
class _$MemoFilterStateCopyWithImpl<$Res>
    implements $MemoFilterStateCopyWith<$Res> {
  _$MemoFilterStateCopyWithImpl(this._self, this._then);

  final MemoFilterState _self;
  final $Res Function(MemoFilterState) _then;

/// Create a copy of MemoFilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dateFilter = null,Object? selectedTypes = null,}) {
  return _then(_self.copyWith(
dateFilter: null == dateFilter ? _self.dateFilter : dateFilter // ignore: cast_nullable_to_non_nullable
as DateFilter,selectedTypes: null == selectedTypes ? _self.selectedTypes : selectedTypes // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoFilterState].
extension MemoFilterStatePatterns on MemoFilterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoFilterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoFilterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoFilterState value)  $default,){
final _that = this;
switch (_that) {
case _MemoFilterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoFilterState value)?  $default,){
final _that = this;
switch (_that) {
case _MemoFilterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateFilter dateFilter,  Set<String> selectedTypes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoFilterState() when $default != null:
return $default(_that.dateFilter,_that.selectedTypes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateFilter dateFilter,  Set<String> selectedTypes)  $default,) {final _that = this;
switch (_that) {
case _MemoFilterState():
return $default(_that.dateFilter,_that.selectedTypes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateFilter dateFilter,  Set<String> selectedTypes)?  $default,) {final _that = this;
switch (_that) {
case _MemoFilterState() when $default != null:
return $default(_that.dateFilter,_that.selectedTypes);case _:
  return null;

}
}

}

/// @nodoc


class _MemoFilterState implements MemoFilterState {
  const _MemoFilterState({this.dateFilter = DateFilter.all, final  Set<String> selectedTypes = const {}}): _selectedTypes = selectedTypes;
  

@override@JsonKey() final  DateFilter dateFilter;
 final  Set<String> _selectedTypes;
@override@JsonKey() Set<String> get selectedTypes {
  if (_selectedTypes is EqualUnmodifiableSetView) return _selectedTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedTypes);
}


/// Create a copy of MemoFilterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoFilterStateCopyWith<_MemoFilterState> get copyWith => __$MemoFilterStateCopyWithImpl<_MemoFilterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoFilterState&&(identical(other.dateFilter, dateFilter) || other.dateFilter == dateFilter)&&const DeepCollectionEquality().equals(other._selectedTypes, _selectedTypes));
}


@override
int get hashCode => Object.hash(runtimeType,dateFilter,const DeepCollectionEquality().hash(_selectedTypes));

@override
String toString() {
  return 'MemoFilterState(dateFilter: $dateFilter, selectedTypes: $selectedTypes)';
}


}

/// @nodoc
abstract mixin class _$MemoFilterStateCopyWith<$Res> implements $MemoFilterStateCopyWith<$Res> {
  factory _$MemoFilterStateCopyWith(_MemoFilterState value, $Res Function(_MemoFilterState) _then) = __$MemoFilterStateCopyWithImpl;
@override @useResult
$Res call({
 DateFilter dateFilter, Set<String> selectedTypes
});




}
/// @nodoc
class __$MemoFilterStateCopyWithImpl<$Res>
    implements _$MemoFilterStateCopyWith<$Res> {
  __$MemoFilterStateCopyWithImpl(this._self, this._then);

  final _MemoFilterState _self;
  final $Res Function(_MemoFilterState) _then;

/// Create a copy of MemoFilterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dateFilter = null,Object? selectedTypes = null,}) {
  return _then(_MemoFilterState(
dateFilter: null == dateFilter ? _self.dateFilter : dateFilter // ignore: cast_nullable_to_non_nullable
as DateFilter,selectedTypes: null == selectedTypes ? _self._selectedTypes : selectedTypes // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
