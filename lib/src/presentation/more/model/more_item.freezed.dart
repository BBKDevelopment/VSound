// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'more_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MoreItem {
  String get iconPath => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MoreItemCopyWith<MoreItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoreItemCopyWith<$Res> {
  factory $MoreItemCopyWith(MoreItem value, $Res Function(MoreItem) then) =
      _$MoreItemCopyWithImpl<$Res, MoreItem>;
  @useResult
  $Res call({String iconPath, String title});
}

/// @nodoc
class _$MoreItemCopyWithImpl<$Res, $Val extends MoreItem>
    implements $MoreItemCopyWith<$Res> {
  _$MoreItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iconPath = null,
    Object? title = null,
  }) {
    return _then(_value.copyWith(
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoreItemImplCopyWith<$Res>
    implements $MoreItemCopyWith<$Res> {
  factory _$$MoreItemImplCopyWith(
          _$MoreItemImpl value, $Res Function(_$MoreItemImpl) then) =
      __$$MoreItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String iconPath, String title});
}

/// @nodoc
class __$$MoreItemImplCopyWithImpl<$Res>
    extends _$MoreItemCopyWithImpl<$Res, _$MoreItemImpl>
    implements _$$MoreItemImplCopyWith<$Res> {
  __$$MoreItemImplCopyWithImpl(
      _$MoreItemImpl _value, $Res Function(_$MoreItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iconPath = null,
    Object? title = null,
  }) {
    return _then(_$MoreItemImpl(
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MoreItemImpl implements _MoreItem {
  const _$MoreItemImpl({required this.iconPath, required this.title});

  @override
  final String iconPath;
  @override
  final String title;

  @override
  String toString() {
    return 'MoreItem(iconPath: $iconPath, title: $title)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoreItemImpl &&
            (identical(other.iconPath, iconPath) ||
                other.iconPath == iconPath) &&
            (identical(other.title, title) || other.title == title));
  }

  @override
  int get hashCode => Object.hash(runtimeType, iconPath, title);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoreItemImplCopyWith<_$MoreItemImpl> get copyWith =>
      __$$MoreItemImplCopyWithImpl<_$MoreItemImpl>(this, _$identity);
}

abstract class _MoreItem implements MoreItem {
  const factory _MoreItem(
      {required final String iconPath,
      required final String title}) = _$MoreItemImpl;

  @override
  String get iconPath;
  @override
  String get title;
  @override
  @JsonKey(ignore: true)
  _$$MoreItemImplCopyWith<_$MoreItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
