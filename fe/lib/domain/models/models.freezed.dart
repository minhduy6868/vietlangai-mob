// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Language {

 String get code;@JsonKey(name: 'iso639_3') String get iso6393; String get nameVi; String get nameEn; String get script; String get family; String get role; int get evaluationTier; String get orthography;
/// Create a copy of Language
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LanguageCopyWith<Language> get copyWith => _$LanguageCopyWithImpl<Language>(this as Language, _$identity);

  /// Serializes this Language to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Language&&(identical(other.code, code) || other.code == code)&&(identical(other.iso6393, iso6393) || other.iso6393 == iso6393)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.script, script) || other.script == script)&&(identical(other.family, family) || other.family == family)&&(identical(other.role, role) || other.role == role)&&(identical(other.evaluationTier, evaluationTier) || other.evaluationTier == evaluationTier)&&(identical(other.orthography, orthography) || other.orthography == orthography));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,iso6393,nameVi,nameEn,script,family,role,evaluationTier,orthography);

@override
String toString() {
  return 'Language(code: $code, iso6393: $iso6393, nameVi: $nameVi, nameEn: $nameEn, script: $script, family: $family, role: $role, evaluationTier: $evaluationTier, orthography: $orthography)';
}


}

/// @nodoc
abstract mixin class $LanguageCopyWith<$Res>  {
  factory $LanguageCopyWith(Language value, $Res Function(Language) _then) = _$LanguageCopyWithImpl;
@useResult
$Res call({
 String code,@JsonKey(name: 'iso639_3') String iso6393, String nameVi, String nameEn, String script, String family, String role, int evaluationTier, String orthography
});




}
/// @nodoc
class _$LanguageCopyWithImpl<$Res>
    implements $LanguageCopyWith<$Res> {
  _$LanguageCopyWithImpl(this._self, this._then);

  final Language _self;
  final $Res Function(Language) _then;

/// Create a copy of Language
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? iso6393 = null,Object? nameVi = null,Object? nameEn = null,Object? script = null,Object? family = null,Object? role = null,Object? evaluationTier = null,Object? orthography = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,iso6393: null == iso6393 ? _self.iso6393 : iso6393 // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,script: null == script ? _self.script : script // ignore: cast_nullable_to_non_nullable
as String,family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,evaluationTier: null == evaluationTier ? _self.evaluationTier : evaluationTier // ignore: cast_nullable_to_non_nullable
as int,orthography: null == orthography ? _self.orthography : orthography // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Language].
extension LanguagePatterns on Language {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Language value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Language() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Language value)  $default,){
final _that = this;
switch (_that) {
case _Language():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Language value)?  $default,){
final _that = this;
switch (_that) {
case _Language() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code, @JsonKey(name: 'iso639_3')  String iso6393,  String nameVi,  String nameEn,  String script,  String family,  String role,  int evaluationTier,  String orthography)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Language() when $default != null:
return $default(_that.code,_that.iso6393,_that.nameVi,_that.nameEn,_that.script,_that.family,_that.role,_that.evaluationTier,_that.orthography);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code, @JsonKey(name: 'iso639_3')  String iso6393,  String nameVi,  String nameEn,  String script,  String family,  String role,  int evaluationTier,  String orthography)  $default,) {final _that = this;
switch (_that) {
case _Language():
return $default(_that.code,_that.iso6393,_that.nameVi,_that.nameEn,_that.script,_that.family,_that.role,_that.evaluationTier,_that.orthography);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code, @JsonKey(name: 'iso639_3')  String iso6393,  String nameVi,  String nameEn,  String script,  String family,  String role,  int evaluationTier,  String orthography)?  $default,) {final _that = this;
switch (_that) {
case _Language() when $default != null:
return $default(_that.code,_that.iso6393,_that.nameVi,_that.nameEn,_that.script,_that.family,_that.role,_that.evaluationTier,_that.orthography);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Language implements Language {
  const _Language({required this.code, @JsonKey(name: 'iso639_3') required this.iso6393, required this.nameVi, required this.nameEn, required this.script, required this.family, required this.role, required this.evaluationTier, required this.orthography});
  factory _Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);

@override final  String code;
@override@JsonKey(name: 'iso639_3') final  String iso6393;
@override final  String nameVi;
@override final  String nameEn;
@override final  String script;
@override final  String family;
@override final  String role;
@override final  int evaluationTier;
@override final  String orthography;

/// Create a copy of Language
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LanguageCopyWith<_Language> get copyWith => __$LanguageCopyWithImpl<_Language>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LanguageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Language&&(identical(other.code, code) || other.code == code)&&(identical(other.iso6393, iso6393) || other.iso6393 == iso6393)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.script, script) || other.script == script)&&(identical(other.family, family) || other.family == family)&&(identical(other.role, role) || other.role == role)&&(identical(other.evaluationTier, evaluationTier) || other.evaluationTier == evaluationTier)&&(identical(other.orthography, orthography) || other.orthography == orthography));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,iso6393,nameVi,nameEn,script,family,role,evaluationTier,orthography);

@override
String toString() {
  return 'Language(code: $code, iso6393: $iso6393, nameVi: $nameVi, nameEn: $nameEn, script: $script, family: $family, role: $role, evaluationTier: $evaluationTier, orthography: $orthography)';
}


}

/// @nodoc
abstract mixin class _$LanguageCopyWith<$Res> implements $LanguageCopyWith<$Res> {
  factory _$LanguageCopyWith(_Language value, $Res Function(_Language) _then) = __$LanguageCopyWithImpl;
@override @useResult
$Res call({
 String code,@JsonKey(name: 'iso639_3') String iso6393, String nameVi, String nameEn, String script, String family, String role, int evaluationTier, String orthography
});




}
/// @nodoc
class __$LanguageCopyWithImpl<$Res>
    implements _$LanguageCopyWith<$Res> {
  __$LanguageCopyWithImpl(this._self, this._then);

  final _Language _self;
  final $Res Function(_Language) _then;

/// Create a copy of Language
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? iso6393 = null,Object? nameVi = null,Object? nameEn = null,Object? script = null,Object? family = null,Object? role = null,Object? evaluationTier = null,Object? orthography = null,}) {
  return _then(_Language(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,iso6393: null == iso6393 ? _self.iso6393 : iso6393 // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,script: null == script ? _self.script : script // ignore: cast_nullable_to_non_nullable
as String,family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,evaluationTier: null == evaluationTier ? _self.evaluationTier : evaluationTier // ignore: cast_nullable_to_non_nullable
as int,orthography: null == orthography ? _self.orthography : orthography // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$People {

 String get slug; String get nameVi; String get nameEn; String get family; String get regionVi; String get regionEn; String get languageCode; String? get originVi; String? get originEn;
/// Create a copy of People
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PeopleCopyWith<People> get copyWith => _$PeopleCopyWithImpl<People>(this as People, _$identity);

  /// Serializes this People to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is People&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.family, family) || other.family == family)&&(identical(other.regionVi, regionVi) || other.regionVi == regionVi)&&(identical(other.regionEn, regionEn) || other.regionEn == regionEn)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.originVi, originVi) || other.originVi == originVi)&&(identical(other.originEn, originEn) || other.originEn == originEn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,nameVi,nameEn,family,regionVi,regionEn,languageCode,originVi,originEn);

@override
String toString() {
  return 'People(slug: $slug, nameVi: $nameVi, nameEn: $nameEn, family: $family, regionVi: $regionVi, regionEn: $regionEn, languageCode: $languageCode, originVi: $originVi, originEn: $originEn)';
}


}

/// @nodoc
abstract mixin class $PeopleCopyWith<$Res>  {
  factory $PeopleCopyWith(People value, $Res Function(People) _then) = _$PeopleCopyWithImpl;
@useResult
$Res call({
 String slug, String nameVi, String nameEn, String family, String regionVi, String regionEn, String languageCode, String? originVi, String? originEn
});




}
/// @nodoc
class _$PeopleCopyWithImpl<$Res>
    implements $PeopleCopyWith<$Res> {
  _$PeopleCopyWithImpl(this._self, this._then);

  final People _self;
  final $Res Function(People) _then;

/// Create a copy of People
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? nameVi = null,Object? nameEn = null,Object? family = null,Object? regionVi = null,Object? regionEn = null,Object? languageCode = null,Object? originVi = freezed,Object? originEn = freezed,}) {
  return _then(_self.copyWith(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String,regionVi: null == regionVi ? _self.regionVi : regionVi // ignore: cast_nullable_to_non_nullable
as String,regionEn: null == regionEn ? _self.regionEn : regionEn // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,originVi: freezed == originVi ? _self.originVi : originVi // ignore: cast_nullable_to_non_nullable
as String?,originEn: freezed == originEn ? _self.originEn : originEn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [People].
extension PeoplePatterns on People {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _People value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _People() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _People value)  $default,){
final _that = this;
switch (_that) {
case _People():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _People value)?  $default,){
final _that = this;
switch (_that) {
case _People() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  String nameVi,  String nameEn,  String family,  String regionVi,  String regionEn,  String languageCode,  String? originVi,  String? originEn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _People() when $default != null:
return $default(_that.slug,_that.nameVi,_that.nameEn,_that.family,_that.regionVi,_that.regionEn,_that.languageCode,_that.originVi,_that.originEn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  String nameVi,  String nameEn,  String family,  String regionVi,  String regionEn,  String languageCode,  String? originVi,  String? originEn)  $default,) {final _that = this;
switch (_that) {
case _People():
return $default(_that.slug,_that.nameVi,_that.nameEn,_that.family,_that.regionVi,_that.regionEn,_that.languageCode,_that.originVi,_that.originEn);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  String nameVi,  String nameEn,  String family,  String regionVi,  String regionEn,  String languageCode,  String? originVi,  String? originEn)?  $default,) {final _that = this;
switch (_that) {
case _People() when $default != null:
return $default(_that.slug,_that.nameVi,_that.nameEn,_that.family,_that.regionVi,_that.regionEn,_that.languageCode,_that.originVi,_that.originEn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _People implements People {
  const _People({required this.slug, required this.nameVi, required this.nameEn, required this.family, required this.regionVi, required this.regionEn, required this.languageCode, this.originVi, this.originEn});
  factory _People.fromJson(Map<String, dynamic> json) => _$PeopleFromJson(json);

@override final  String slug;
@override final  String nameVi;
@override final  String nameEn;
@override final  String family;
@override final  String regionVi;
@override final  String regionEn;
@override final  String languageCode;
@override final  String? originVi;
@override final  String? originEn;

/// Create a copy of People
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PeopleCopyWith<_People> get copyWith => __$PeopleCopyWithImpl<_People>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PeopleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _People&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.family, family) || other.family == family)&&(identical(other.regionVi, regionVi) || other.regionVi == regionVi)&&(identical(other.regionEn, regionEn) || other.regionEn == regionEn)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.originVi, originVi) || other.originVi == originVi)&&(identical(other.originEn, originEn) || other.originEn == originEn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slug,nameVi,nameEn,family,regionVi,regionEn,languageCode,originVi,originEn);

@override
String toString() {
  return 'People(slug: $slug, nameVi: $nameVi, nameEn: $nameEn, family: $family, regionVi: $regionVi, regionEn: $regionEn, languageCode: $languageCode, originVi: $originVi, originEn: $originEn)';
}


}

/// @nodoc
abstract mixin class _$PeopleCopyWith<$Res> implements $PeopleCopyWith<$Res> {
  factory _$PeopleCopyWith(_People value, $Res Function(_People) _then) = __$PeopleCopyWithImpl;
@override @useResult
$Res call({
 String slug, String nameVi, String nameEn, String family, String regionVi, String regionEn, String languageCode, String? originVi, String? originEn
});




}
/// @nodoc
class __$PeopleCopyWithImpl<$Res>
    implements _$PeopleCopyWith<$Res> {
  __$PeopleCopyWithImpl(this._self, this._then);

  final _People _self;
  final $Res Function(_People) _then;

/// Create a copy of People
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? nameVi = null,Object? nameEn = null,Object? family = null,Object? regionVi = null,Object? regionEn = null,Object? languageCode = null,Object? originVi = freezed,Object? originEn = freezed,}) {
  return _then(_People(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String,regionVi: null == regionVi ? _self.regionVi : regionVi // ignore: cast_nullable_to_non_nullable
as String,regionEn: null == regionEn ? _self.regionEn : regionEn // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,originVi: freezed == originVi ? _self.originVi : originVi // ignore: cast_nullable_to_non_nullable
as String?,originEn: freezed == originEn ? _self.originEn : originEn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HeritageItem {

 String get id; String get kind; String get titleVi; String get titleEn; String get bodyVi; String get bodyEn; String? get mediaUrl; String? get groupSlug;
/// Create a copy of HeritageItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeritageItemCopyWith<HeritageItem> get copyWith => _$HeritageItemCopyWithImpl<HeritageItem>(this as HeritageItem, _$identity);

  /// Serializes this HeritageItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeritageItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.bodyVi, bodyVi) || other.bodyVi == bodyVi)&&(identical(other.bodyEn, bodyEn) || other.bodyEn == bodyEn)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.groupSlug, groupSlug) || other.groupSlug == groupSlug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,titleVi,titleEn,bodyVi,bodyEn,mediaUrl,groupSlug);

@override
String toString() {
  return 'HeritageItem(id: $id, kind: $kind, titleVi: $titleVi, titleEn: $titleEn, bodyVi: $bodyVi, bodyEn: $bodyEn, mediaUrl: $mediaUrl, groupSlug: $groupSlug)';
}


}

/// @nodoc
abstract mixin class $HeritageItemCopyWith<$Res>  {
  factory $HeritageItemCopyWith(HeritageItem value, $Res Function(HeritageItem) _then) = _$HeritageItemCopyWithImpl;
@useResult
$Res call({
 String id, String kind, String titleVi, String titleEn, String bodyVi, String bodyEn, String? mediaUrl, String? groupSlug
});




}
/// @nodoc
class _$HeritageItemCopyWithImpl<$Res>
    implements $HeritageItemCopyWith<$Res> {
  _$HeritageItemCopyWithImpl(this._self, this._then);

  final HeritageItem _self;
  final $Res Function(HeritageItem) _then;

/// Create a copy of HeritageItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? titleVi = null,Object? titleEn = null,Object? bodyVi = null,Object? bodyEn = null,Object? mediaUrl = freezed,Object? groupSlug = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,bodyVi: null == bodyVi ? _self.bodyVi : bodyVi // ignore: cast_nullable_to_non_nullable
as String,bodyEn: null == bodyEn ? _self.bodyEn : bodyEn // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,groupSlug: freezed == groupSlug ? _self.groupSlug : groupSlug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HeritageItem].
extension HeritageItemPatterns on HeritageItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeritageItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeritageItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeritageItem value)  $default,){
final _that = this;
switch (_that) {
case _HeritageItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeritageItem value)?  $default,){
final _that = this;
switch (_that) {
case _HeritageItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String kind,  String titleVi,  String titleEn,  String bodyVi,  String bodyEn,  String? mediaUrl,  String? groupSlug)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeritageItem() when $default != null:
return $default(_that.id,_that.kind,_that.titleVi,_that.titleEn,_that.bodyVi,_that.bodyEn,_that.mediaUrl,_that.groupSlug);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String kind,  String titleVi,  String titleEn,  String bodyVi,  String bodyEn,  String? mediaUrl,  String? groupSlug)  $default,) {final _that = this;
switch (_that) {
case _HeritageItem():
return $default(_that.id,_that.kind,_that.titleVi,_that.titleEn,_that.bodyVi,_that.bodyEn,_that.mediaUrl,_that.groupSlug);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String kind,  String titleVi,  String titleEn,  String bodyVi,  String bodyEn,  String? mediaUrl,  String? groupSlug)?  $default,) {final _that = this;
switch (_that) {
case _HeritageItem() when $default != null:
return $default(_that.id,_that.kind,_that.titleVi,_that.titleEn,_that.bodyVi,_that.bodyEn,_that.mediaUrl,_that.groupSlug);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HeritageItem implements HeritageItem {
  const _HeritageItem({required this.id, required this.kind, required this.titleVi, required this.titleEn, required this.bodyVi, required this.bodyEn, this.mediaUrl, this.groupSlug});
  factory _HeritageItem.fromJson(Map<String, dynamic> json) => _$HeritageItemFromJson(json);

@override final  String id;
@override final  String kind;
@override final  String titleVi;
@override final  String titleEn;
@override final  String bodyVi;
@override final  String bodyEn;
@override final  String? mediaUrl;
@override final  String? groupSlug;

/// Create a copy of HeritageItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeritageItemCopyWith<_HeritageItem> get copyWith => __$HeritageItemCopyWithImpl<_HeritageItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeritageItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeritageItem&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.bodyVi, bodyVi) || other.bodyVi == bodyVi)&&(identical(other.bodyEn, bodyEn) || other.bodyEn == bodyEn)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.groupSlug, groupSlug) || other.groupSlug == groupSlug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,titleVi,titleEn,bodyVi,bodyEn,mediaUrl,groupSlug);

@override
String toString() {
  return 'HeritageItem(id: $id, kind: $kind, titleVi: $titleVi, titleEn: $titleEn, bodyVi: $bodyVi, bodyEn: $bodyEn, mediaUrl: $mediaUrl, groupSlug: $groupSlug)';
}


}

/// @nodoc
abstract mixin class _$HeritageItemCopyWith<$Res> implements $HeritageItemCopyWith<$Res> {
  factory _$HeritageItemCopyWith(_HeritageItem value, $Res Function(_HeritageItem) _then) = __$HeritageItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String kind, String titleVi, String titleEn, String bodyVi, String bodyEn, String? mediaUrl, String? groupSlug
});




}
/// @nodoc
class __$HeritageItemCopyWithImpl<$Res>
    implements _$HeritageItemCopyWith<$Res> {
  __$HeritageItemCopyWithImpl(this._self, this._then);

  final _HeritageItem _self;
  final $Res Function(_HeritageItem) _then;

/// Create a copy of HeritageItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? titleVi = null,Object? titleEn = null,Object? bodyVi = null,Object? bodyEn = null,Object? mediaUrl = freezed,Object? groupSlug = freezed,}) {
  return _then(_HeritageItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,bodyVi: null == bodyVi ? _self.bodyVi : bodyVi // ignore: cast_nullable_to_non_nullable
as String,bodyEn: null == bodyEn ? _self.bodyEn : bodyEn // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,groupSlug: freezed == groupSlug ? _self.groupSlug : groupSlug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Phrase {

 String get id; String get nativeText; String get viText; String get enText; String? get source;
/// Create a copy of Phrase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhraseCopyWith<Phrase> get copyWith => _$PhraseCopyWithImpl<Phrase>(this as Phrase, _$identity);

  /// Serializes this Phrase to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Phrase&&(identical(other.id, id) || other.id == id)&&(identical(other.nativeText, nativeText) || other.nativeText == nativeText)&&(identical(other.viText, viText) || other.viText == viText)&&(identical(other.enText, enText) || other.enText == enText)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nativeText,viText,enText,source);

@override
String toString() {
  return 'Phrase(id: $id, nativeText: $nativeText, viText: $viText, enText: $enText, source: $source)';
}


}

/// @nodoc
abstract mixin class $PhraseCopyWith<$Res>  {
  factory $PhraseCopyWith(Phrase value, $Res Function(Phrase) _then) = _$PhraseCopyWithImpl;
@useResult
$Res call({
 String id, String nativeText, String viText, String enText, String? source
});




}
/// @nodoc
class _$PhraseCopyWithImpl<$Res>
    implements $PhraseCopyWith<$Res> {
  _$PhraseCopyWithImpl(this._self, this._then);

  final Phrase _self;
  final $Res Function(Phrase) _then;

/// Create a copy of Phrase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nativeText = null,Object? viText = null,Object? enText = null,Object? source = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nativeText: null == nativeText ? _self.nativeText : nativeText // ignore: cast_nullable_to_non_nullable
as String,viText: null == viText ? _self.viText : viText // ignore: cast_nullable_to_non_nullable
as String,enText: null == enText ? _self.enText : enText // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Phrase].
extension PhrasePatterns on Phrase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Phrase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Phrase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Phrase value)  $default,){
final _that = this;
switch (_that) {
case _Phrase():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Phrase value)?  $default,){
final _that = this;
switch (_that) {
case _Phrase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nativeText,  String viText,  String enText,  String? source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Phrase() when $default != null:
return $default(_that.id,_that.nativeText,_that.viText,_that.enText,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nativeText,  String viText,  String enText,  String? source)  $default,) {final _that = this;
switch (_that) {
case _Phrase():
return $default(_that.id,_that.nativeText,_that.viText,_that.enText,_that.source);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nativeText,  String viText,  String enText,  String? source)?  $default,) {final _that = this;
switch (_that) {
case _Phrase() when $default != null:
return $default(_that.id,_that.nativeText,_that.viText,_that.enText,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Phrase implements Phrase {
  const _Phrase({required this.id, required this.nativeText, required this.viText, required this.enText, this.source});
  factory _Phrase.fromJson(Map<String, dynamic> json) => _$PhraseFromJson(json);

@override final  String id;
@override final  String nativeText;
@override final  String viText;
@override final  String enText;
@override final  String? source;

/// Create a copy of Phrase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhraseCopyWith<_Phrase> get copyWith => __$PhraseCopyWithImpl<_Phrase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhraseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Phrase&&(identical(other.id, id) || other.id == id)&&(identical(other.nativeText, nativeText) || other.nativeText == nativeText)&&(identical(other.viText, viText) || other.viText == viText)&&(identical(other.enText, enText) || other.enText == enText)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nativeText,viText,enText,source);

@override
String toString() {
  return 'Phrase(id: $id, nativeText: $nativeText, viText: $viText, enText: $enText, source: $source)';
}


}

/// @nodoc
abstract mixin class _$PhraseCopyWith<$Res> implements $PhraseCopyWith<$Res> {
  factory _$PhraseCopyWith(_Phrase value, $Res Function(_Phrase) _then) = __$PhraseCopyWithImpl;
@override @useResult
$Res call({
 String id, String nativeText, String viText, String enText, String? source
});




}
/// @nodoc
class __$PhraseCopyWithImpl<$Res>
    implements _$PhraseCopyWith<$Res> {
  __$PhraseCopyWithImpl(this._self, this._then);

  final _Phrase _self;
  final $Res Function(_Phrase) _then;

/// Create a copy of Phrase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nativeText = null,Object? viText = null,Object? enText = null,Object? source = freezed,}) {
  return _then(_Phrase(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nativeText: null == nativeText ? _self.nativeText : nativeText // ignore: cast_nullable_to_non_nullable
as String,viText: null == viText ? _self.viText : viText // ignore: cast_nullable_to_non_nullable
as String,enText: null == enText ? _self.enText : enText // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$QuizChoice {

 String get id; String get textVi; String get textEn;
/// Create a copy of QuizChoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizChoiceCopyWith<QuizChoice> get copyWith => _$QuizChoiceCopyWithImpl<QuizChoice>(this as QuizChoice, _$identity);

  /// Serializes this QuizChoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizChoice&&(identical(other.id, id) || other.id == id)&&(identical(other.textVi, textVi) || other.textVi == textVi)&&(identical(other.textEn, textEn) || other.textEn == textEn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,textVi,textEn);

@override
String toString() {
  return 'QuizChoice(id: $id, textVi: $textVi, textEn: $textEn)';
}


}

/// @nodoc
abstract mixin class $QuizChoiceCopyWith<$Res>  {
  factory $QuizChoiceCopyWith(QuizChoice value, $Res Function(QuizChoice) _then) = _$QuizChoiceCopyWithImpl;
@useResult
$Res call({
 String id, String textVi, String textEn
});




}
/// @nodoc
class _$QuizChoiceCopyWithImpl<$Res>
    implements $QuizChoiceCopyWith<$Res> {
  _$QuizChoiceCopyWithImpl(this._self, this._then);

  final QuizChoice _self;
  final $Res Function(QuizChoice) _then;

/// Create a copy of QuizChoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? textVi = null,Object? textEn = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,textVi: null == textVi ? _self.textVi : textVi // ignore: cast_nullable_to_non_nullable
as String,textEn: null == textEn ? _self.textEn : textEn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizChoice].
extension QuizChoicePatterns on QuizChoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizChoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizChoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizChoice value)  $default,){
final _that = this;
switch (_that) {
case _QuizChoice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizChoice value)?  $default,){
final _that = this;
switch (_that) {
case _QuizChoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String textVi,  String textEn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizChoice() when $default != null:
return $default(_that.id,_that.textVi,_that.textEn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String textVi,  String textEn)  $default,) {final _that = this;
switch (_that) {
case _QuizChoice():
return $default(_that.id,_that.textVi,_that.textEn);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String textVi,  String textEn)?  $default,) {final _that = this;
switch (_that) {
case _QuizChoice() when $default != null:
return $default(_that.id,_that.textVi,_that.textEn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizChoice implements QuizChoice {
  const _QuizChoice({required this.id, required this.textVi, required this.textEn});
  factory _QuizChoice.fromJson(Map<String, dynamic> json) => _$QuizChoiceFromJson(json);

@override final  String id;
@override final  String textVi;
@override final  String textEn;

/// Create a copy of QuizChoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizChoiceCopyWith<_QuizChoice> get copyWith => __$QuizChoiceCopyWithImpl<_QuizChoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizChoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizChoice&&(identical(other.id, id) || other.id == id)&&(identical(other.textVi, textVi) || other.textVi == textVi)&&(identical(other.textEn, textEn) || other.textEn == textEn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,textVi,textEn);

@override
String toString() {
  return 'QuizChoice(id: $id, textVi: $textVi, textEn: $textEn)';
}


}

/// @nodoc
abstract mixin class _$QuizChoiceCopyWith<$Res> implements $QuizChoiceCopyWith<$Res> {
  factory _$QuizChoiceCopyWith(_QuizChoice value, $Res Function(_QuizChoice) _then) = __$QuizChoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String textVi, String textEn
});




}
/// @nodoc
class __$QuizChoiceCopyWithImpl<$Res>
    implements _$QuizChoiceCopyWith<$Res> {
  __$QuizChoiceCopyWithImpl(this._self, this._then);

  final _QuizChoice _self;
  final $Res Function(_QuizChoice) _then;

/// Create a copy of QuizChoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? textVi = null,Object? textEn = null,}) {
  return _then(_QuizChoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,textVi: null == textVi ? _self.textVi : textVi // ignore: cast_nullable_to_non_nullable
as String,textEn: null == textEn ? _self.textEn : textEn // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$QuizQuestion {

 String get id; String get promptVi; String get promptEn; List<QuizChoice> get choices;
/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizQuestionCopyWith<QuizQuestion> get copyWith => _$QuizQuestionCopyWithImpl<QuizQuestion>(this as QuizQuestion, _$identity);

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.promptVi, promptVi) || other.promptVi == promptVi)&&(identical(other.promptEn, promptEn) || other.promptEn == promptEn)&&const DeepCollectionEquality().equals(other.choices, choices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,promptVi,promptEn,const DeepCollectionEquality().hash(choices));

@override
String toString() {
  return 'QuizQuestion(id: $id, promptVi: $promptVi, promptEn: $promptEn, choices: $choices)';
}


}

/// @nodoc
abstract mixin class $QuizQuestionCopyWith<$Res>  {
  factory $QuizQuestionCopyWith(QuizQuestion value, $Res Function(QuizQuestion) _then) = _$QuizQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String promptVi, String promptEn, List<QuizChoice> choices
});




}
/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._self, this._then);

  final QuizQuestion _self;
  final $Res Function(QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? promptVi = null,Object? promptEn = null,Object? choices = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,promptVi: null == promptVi ? _self.promptVi : promptVi // ignore: cast_nullable_to_non_nullable
as String,promptEn: null == promptEn ? _self.promptEn : promptEn // ignore: cast_nullable_to_non_nullable
as String,choices: null == choices ? _self.choices : choices // ignore: cast_nullable_to_non_nullable
as List<QuizChoice>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizQuestion].
extension QuizQuestionPatterns on QuizQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizQuestion value)  $default,){
final _that = this;
switch (_that) {
case _QuizQuestion():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String promptVi,  String promptEn,  List<QuizChoice> choices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
return $default(_that.id,_that.promptVi,_that.promptEn,_that.choices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String promptVi,  String promptEn,  List<QuizChoice> choices)  $default,) {final _that = this;
switch (_that) {
case _QuizQuestion():
return $default(_that.id,_that.promptVi,_that.promptEn,_that.choices);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String promptVi,  String promptEn,  List<QuizChoice> choices)?  $default,) {final _that = this;
switch (_that) {
case _QuizQuestion() when $default != null:
return $default(_that.id,_that.promptVi,_that.promptEn,_that.choices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizQuestion implements QuizQuestion {
  const _QuizQuestion({required this.id, required this.promptVi, required this.promptEn, final  List<QuizChoice> choices = const []}): _choices = choices;
  factory _QuizQuestion.fromJson(Map<String, dynamic> json) => _$QuizQuestionFromJson(json);

@override final  String id;
@override final  String promptVi;
@override final  String promptEn;
 final  List<QuizChoice> _choices;
@override@JsonKey() List<QuizChoice> get choices {
  if (_choices is EqualUnmodifiableListView) return _choices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_choices);
}


/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizQuestionCopyWith<_QuizQuestion> get copyWith => __$QuizQuestionCopyWithImpl<_QuizQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.promptVi, promptVi) || other.promptVi == promptVi)&&(identical(other.promptEn, promptEn) || other.promptEn == promptEn)&&const DeepCollectionEquality().equals(other._choices, _choices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,promptVi,promptEn,const DeepCollectionEquality().hash(_choices));

@override
String toString() {
  return 'QuizQuestion(id: $id, promptVi: $promptVi, promptEn: $promptEn, choices: $choices)';
}


}

/// @nodoc
abstract mixin class _$QuizQuestionCopyWith<$Res> implements $QuizQuestionCopyWith<$Res> {
  factory _$QuizQuestionCopyWith(_QuizQuestion value, $Res Function(_QuizQuestion) _then) = __$QuizQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String promptVi, String promptEn, List<QuizChoice> choices
});




}
/// @nodoc
class __$QuizQuestionCopyWithImpl<$Res>
    implements _$QuizQuestionCopyWith<$Res> {
  __$QuizQuestionCopyWithImpl(this._self, this._then);

  final _QuizQuestion _self;
  final $Res Function(_QuizQuestion) _then;

/// Create a copy of QuizQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? promptVi = null,Object? promptEn = null,Object? choices = null,}) {
  return _then(_QuizQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,promptVi: null == promptVi ? _self.promptVi : promptVi // ignore: cast_nullable_to_non_nullable
as String,promptEn: null == promptEn ? _self.promptEn : promptEn // ignore: cast_nullable_to_non_nullable
as String,choices: null == choices ? _self._choices : choices // ignore: cast_nullable_to_non_nullable
as List<QuizChoice>,
  ));
}


}


/// @nodoc
mixin _$Lesson {

 String get id; String get languageCode; String get titleVi; String get titleEn; String get summaryVi; String get summaryEn; String get level; List<Phrase> get phrases; List<QuizQuestion> get questions;
/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCopyWith<Lesson> get copyWith => _$LessonCopyWithImpl<Lesson>(this as Lesson, _$identity);

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.summaryVi, summaryVi) || other.summaryVi == summaryVi)&&(identical(other.summaryEn, summaryEn) || other.summaryEn == summaryEn)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.phrases, phrases)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,languageCode,titleVi,titleEn,summaryVi,summaryEn,level,const DeepCollectionEquality().hash(phrases),const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'Lesson(id: $id, languageCode: $languageCode, titleVi: $titleVi, titleEn: $titleEn, summaryVi: $summaryVi, summaryEn: $summaryEn, level: $level, phrases: $phrases, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $LessonCopyWith<$Res>  {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) _then) = _$LessonCopyWithImpl;
@useResult
$Res call({
 String id, String languageCode, String titleVi, String titleEn, String summaryVi, String summaryEn, String level, List<Phrase> phrases, List<QuizQuestion> questions
});




}
/// @nodoc
class _$LessonCopyWithImpl<$Res>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._self, this._then);

  final Lesson _self;
  final $Res Function(Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? languageCode = null,Object? titleVi = null,Object? titleEn = null,Object? summaryVi = null,Object? summaryEn = null,Object? level = null,Object? phrases = null,Object? questions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,summaryVi: null == summaryVi ? _self.summaryVi : summaryVi // ignore: cast_nullable_to_non_nullable
as String,summaryEn: null == summaryEn ? _self.summaryEn : summaryEn // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,phrases: null == phrases ? _self.phrases : phrases // ignore: cast_nullable_to_non_nullable
as List<Phrase>,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [Lesson].
extension LessonPatterns on Lesson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lesson value)  $default,){
final _that = this;
switch (_that) {
case _Lesson():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lesson value)?  $default,){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String languageCode,  String titleVi,  String titleEn,  String summaryVi,  String summaryEn,  String level,  List<Phrase> phrases,  List<QuizQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.languageCode,_that.titleVi,_that.titleEn,_that.summaryVi,_that.summaryEn,_that.level,_that.phrases,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String languageCode,  String titleVi,  String titleEn,  String summaryVi,  String summaryEn,  String level,  List<Phrase> phrases,  List<QuizQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _Lesson():
return $default(_that.id,_that.languageCode,_that.titleVi,_that.titleEn,_that.summaryVi,_that.summaryEn,_that.level,_that.phrases,_that.questions);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String languageCode,  String titleVi,  String titleEn,  String summaryVi,  String summaryEn,  String level,  List<Phrase> phrases,  List<QuizQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.languageCode,_that.titleVi,_that.titleEn,_that.summaryVi,_that.summaryEn,_that.level,_that.phrases,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lesson implements Lesson {
  const _Lesson({required this.id, required this.languageCode, required this.titleVi, required this.titleEn, required this.summaryVi, required this.summaryEn, required this.level, final  List<Phrase> phrases = const [], final  List<QuizQuestion> questions = const []}): _phrases = phrases,_questions = questions;
  factory _Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

@override final  String id;
@override final  String languageCode;
@override final  String titleVi;
@override final  String titleEn;
@override final  String summaryVi;
@override final  String summaryEn;
@override final  String level;
 final  List<Phrase> _phrases;
@override@JsonKey() List<Phrase> get phrases {
  if (_phrases is EqualUnmodifiableListView) return _phrases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_phrases);
}

 final  List<QuizQuestion> _questions;
@override@JsonKey() List<QuizQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonCopyWith<_Lesson> get copyWith => __$LessonCopyWithImpl<_Lesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.titleVi, titleVi) || other.titleVi == titleVi)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.summaryVi, summaryVi) || other.summaryVi == summaryVi)&&(identical(other.summaryEn, summaryEn) || other.summaryEn == summaryEn)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other._phrases, _phrases)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,languageCode,titleVi,titleEn,summaryVi,summaryEn,level,const DeepCollectionEquality().hash(_phrases),const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'Lesson(id: $id, languageCode: $languageCode, titleVi: $titleVi, titleEn: $titleEn, summaryVi: $summaryVi, summaryEn: $summaryEn, level: $level, phrases: $phrases, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$LessonCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$LessonCopyWith(_Lesson value, $Res Function(_Lesson) _then) = __$LessonCopyWithImpl;
@override @useResult
$Res call({
 String id, String languageCode, String titleVi, String titleEn, String summaryVi, String summaryEn, String level, List<Phrase> phrases, List<QuizQuestion> questions
});




}
/// @nodoc
class __$LessonCopyWithImpl<$Res>
    implements _$LessonCopyWith<$Res> {
  __$LessonCopyWithImpl(this._self, this._then);

  final _Lesson _self;
  final $Res Function(_Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? languageCode = null,Object? titleVi = null,Object? titleEn = null,Object? summaryVi = null,Object? summaryEn = null,Object? level = null,Object? phrases = null,Object? questions = null,}) {
  return _then(_Lesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,titleVi: null == titleVi ? _self.titleVi : titleVi // ignore: cast_nullable_to_non_nullable
as String,titleEn: null == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String,summaryVi: null == summaryVi ? _self.summaryVi : summaryVi // ignore: cast_nullable_to_non_nullable
as String,summaryEn: null == summaryEn ? _self.summaryEn : summaryEn // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,phrases: null == phrases ? _self._phrases : phrases // ignore: cast_nullable_to_non_nullable
as List<Phrase>,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuizQuestion>,
  ));
}


}


/// @nodoc
mixin _$Contribution {

 String get clientId; String get languageCode; String get sourceLang; String get targetLang; String get sourceText; String get targetText; String? get id; String? get note; String get status; String? get reviewNote;
/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContributionCopyWith<Contribution> get copyWith => _$ContributionCopyWithImpl<Contribution>(this as Contribution, _$identity);

  /// Serializes this Contribution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contribution&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.sourceLang, sourceLang) || other.sourceLang == sourceLang)&&(identical(other.targetLang, targetLang) || other.targetLang == targetLang)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.targetText, targetText) || other.targetText == targetText)&&(identical(other.id, id) || other.id == id)&&(identical(other.note, note) || other.note == note)&&(identical(other.status, status) || other.status == status)&&(identical(other.reviewNote, reviewNote) || other.reviewNote == reviewNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientId,languageCode,sourceLang,targetLang,sourceText,targetText,id,note,status,reviewNote);

@override
String toString() {
  return 'Contribution(clientId: $clientId, languageCode: $languageCode, sourceLang: $sourceLang, targetLang: $targetLang, sourceText: $sourceText, targetText: $targetText, id: $id, note: $note, status: $status, reviewNote: $reviewNote)';
}


}

/// @nodoc
abstract mixin class $ContributionCopyWith<$Res>  {
  factory $ContributionCopyWith(Contribution value, $Res Function(Contribution) _then) = _$ContributionCopyWithImpl;
@useResult
$Res call({
 String clientId, String languageCode, String sourceLang, String targetLang, String sourceText, String targetText, String? id, String? note, String status, String? reviewNote
});




}
/// @nodoc
class _$ContributionCopyWithImpl<$Res>
    implements $ContributionCopyWith<$Res> {
  _$ContributionCopyWithImpl(this._self, this._then);

  final Contribution _self;
  final $Res Function(Contribution) _then;

/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientId = null,Object? languageCode = null,Object? sourceLang = null,Object? targetLang = null,Object? sourceText = null,Object? targetText = null,Object? id = freezed,Object? note = freezed,Object? status = null,Object? reviewNote = freezed,}) {
  return _then(_self.copyWith(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,sourceLang: null == sourceLang ? _self.sourceLang : sourceLang // ignore: cast_nullable_to_non_nullable
as String,targetLang: null == targetLang ? _self.targetLang : targetLang // ignore: cast_nullable_to_non_nullable
as String,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,targetText: null == targetText ? _self.targetText : targetText // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reviewNote: freezed == reviewNote ? _self.reviewNote : reviewNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Contribution].
extension ContributionPatterns on Contribution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Contribution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Contribution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Contribution value)  $default,){
final _that = this;
switch (_that) {
case _Contribution():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Contribution value)?  $default,){
final _that = this;
switch (_that) {
case _Contribution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientId,  String languageCode,  String sourceLang,  String targetLang,  String sourceText,  String targetText,  String? id,  String? note,  String status,  String? reviewNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Contribution() when $default != null:
return $default(_that.clientId,_that.languageCode,_that.sourceLang,_that.targetLang,_that.sourceText,_that.targetText,_that.id,_that.note,_that.status,_that.reviewNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientId,  String languageCode,  String sourceLang,  String targetLang,  String sourceText,  String targetText,  String? id,  String? note,  String status,  String? reviewNote)  $default,) {final _that = this;
switch (_that) {
case _Contribution():
return $default(_that.clientId,_that.languageCode,_that.sourceLang,_that.targetLang,_that.sourceText,_that.targetText,_that.id,_that.note,_that.status,_that.reviewNote);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientId,  String languageCode,  String sourceLang,  String targetLang,  String sourceText,  String targetText,  String? id,  String? note,  String status,  String? reviewNote)?  $default,) {final _that = this;
switch (_that) {
case _Contribution() when $default != null:
return $default(_that.clientId,_that.languageCode,_that.sourceLang,_that.targetLang,_that.sourceText,_that.targetText,_that.id,_that.note,_that.status,_that.reviewNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Contribution implements Contribution {
  const _Contribution({required this.clientId, required this.languageCode, required this.sourceLang, required this.targetLang, required this.sourceText, required this.targetText, this.id, this.note, this.status = 'pending', this.reviewNote});
  factory _Contribution.fromJson(Map<String, dynamic> json) => _$ContributionFromJson(json);

@override final  String clientId;
@override final  String languageCode;
@override final  String sourceLang;
@override final  String targetLang;
@override final  String sourceText;
@override final  String targetText;
@override final  String? id;
@override final  String? note;
@override@JsonKey() final  String status;
@override final  String? reviewNote;

/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContributionCopyWith<_Contribution> get copyWith => __$ContributionCopyWithImpl<_Contribution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContributionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contribution&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.sourceLang, sourceLang) || other.sourceLang == sourceLang)&&(identical(other.targetLang, targetLang) || other.targetLang == targetLang)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.targetText, targetText) || other.targetText == targetText)&&(identical(other.id, id) || other.id == id)&&(identical(other.note, note) || other.note == note)&&(identical(other.status, status) || other.status == status)&&(identical(other.reviewNote, reviewNote) || other.reviewNote == reviewNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientId,languageCode,sourceLang,targetLang,sourceText,targetText,id,note,status,reviewNote);

@override
String toString() {
  return 'Contribution(clientId: $clientId, languageCode: $languageCode, sourceLang: $sourceLang, targetLang: $targetLang, sourceText: $sourceText, targetText: $targetText, id: $id, note: $note, status: $status, reviewNote: $reviewNote)';
}


}

/// @nodoc
abstract mixin class _$ContributionCopyWith<$Res> implements $ContributionCopyWith<$Res> {
  factory _$ContributionCopyWith(_Contribution value, $Res Function(_Contribution) _then) = __$ContributionCopyWithImpl;
@override @useResult
$Res call({
 String clientId, String languageCode, String sourceLang, String targetLang, String sourceText, String targetText, String? id, String? note, String status, String? reviewNote
});




}
/// @nodoc
class __$ContributionCopyWithImpl<$Res>
    implements _$ContributionCopyWith<$Res> {
  __$ContributionCopyWithImpl(this._self, this._then);

  final _Contribution _self;
  final $Res Function(_Contribution) _then;

/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientId = null,Object? languageCode = null,Object? sourceLang = null,Object? targetLang = null,Object? sourceText = null,Object? targetText = null,Object? id = freezed,Object? note = freezed,Object? status = null,Object? reviewNote = freezed,}) {
  return _then(_Contribution(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,sourceLang: null == sourceLang ? _self.sourceLang : sourceLang // ignore: cast_nullable_to_non_nullable
as String,targetLang: null == targetLang ? _self.targetLang : targetLang // ignore: cast_nullable_to_non_nullable
as String,sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,targetText: null == targetText ? _self.targetText : targetText // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reviewNote: freezed == reviewNote ? _self.reviewNote : reviewNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TranslationStep {

 String get source; String get target; String get engine; String get text;
/// Create a copy of TranslationStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationStepCopyWith<TranslationStep> get copyWith => _$TranslationStepCopyWithImpl<TranslationStep>(this as TranslationStep, _$identity);

  /// Serializes this TranslationStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationStep&&(identical(other.source, source) || other.source == source)&&(identical(other.target, target) || other.target == target)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,target,engine,text);

@override
String toString() {
  return 'TranslationStep(source: $source, target: $target, engine: $engine, text: $text)';
}


}

/// @nodoc
abstract mixin class $TranslationStepCopyWith<$Res>  {
  factory $TranslationStepCopyWith(TranslationStep value, $Res Function(TranslationStep) _then) = _$TranslationStepCopyWithImpl;
@useResult
$Res call({
 String source, String target, String engine, String text
});




}
/// @nodoc
class _$TranslationStepCopyWithImpl<$Res>
    implements $TranslationStepCopyWith<$Res> {
  _$TranslationStepCopyWithImpl(this._self, this._then);

  final TranslationStep _self;
  final $Res Function(TranslationStep) _then;

/// Create a copy of TranslationStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? target = null,Object? engine = null,Object? text = null,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TranslationStep].
extension TranslationStepPatterns on TranslationStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationStep value)  $default,){
final _that = this;
switch (_that) {
case _TranslationStep():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationStep value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String source,  String target,  String engine,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationStep() when $default != null:
return $default(_that.source,_that.target,_that.engine,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String source,  String target,  String engine,  String text)  $default,) {final _that = this;
switch (_that) {
case _TranslationStep():
return $default(_that.source,_that.target,_that.engine,_that.text);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String source,  String target,  String engine,  String text)?  $default,) {final _that = this;
switch (_that) {
case _TranslationStep() when $default != null:
return $default(_that.source,_that.target,_that.engine,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TranslationStep implements TranslationStep {
  const _TranslationStep({required this.source, required this.target, required this.engine, required this.text});
  factory _TranslationStep.fromJson(Map<String, dynamic> json) => _$TranslationStepFromJson(json);

@override final  String source;
@override final  String target;
@override final  String engine;
@override final  String text;

/// Create a copy of TranslationStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationStepCopyWith<_TranslationStep> get copyWith => __$TranslationStepCopyWithImpl<_TranslationStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranslationStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationStep&&(identical(other.source, source) || other.source == source)&&(identical(other.target, target) || other.target == target)&&(identical(other.engine, engine) || other.engine == engine)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,target,engine,text);

@override
String toString() {
  return 'TranslationStep(source: $source, target: $target, engine: $engine, text: $text)';
}


}

/// @nodoc
abstract mixin class _$TranslationStepCopyWith<$Res> implements $TranslationStepCopyWith<$Res> {
  factory _$TranslationStepCopyWith(_TranslationStep value, $Res Function(_TranslationStep) _then) = __$TranslationStepCopyWithImpl;
@override @useResult
$Res call({
 String source, String target, String engine, String text
});




}
/// @nodoc
class __$TranslationStepCopyWithImpl<$Res>
    implements _$TranslationStepCopyWith<$Res> {
  __$TranslationStepCopyWithImpl(this._self, this._then);

  final _TranslationStep _self;
  final $Res Function(_TranslationStep) _then;

/// Create a copy of TranslationStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? target = null,Object? engine = null,Object? text = null,}) {
  return _then(_TranslationStep(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TranslationResult {

 String get text; String get sourceLang; String get targetLang; String? get detectedLang; String? get recognizedText; String get route; String get engine; List<String> get warnings; List<TranslationStep> get steps;
/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationResultCopyWith<TranslationResult> get copyWith => _$TranslationResultCopyWithImpl<TranslationResult>(this as TranslationResult, _$identity);

  /// Serializes this TranslationResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationResult&&(identical(other.text, text) || other.text == text)&&(identical(other.sourceLang, sourceLang) || other.sourceLang == sourceLang)&&(identical(other.targetLang, targetLang) || other.targetLang == targetLang)&&(identical(other.detectedLang, detectedLang) || other.detectedLang == detectedLang)&&(identical(other.recognizedText, recognizedText) || other.recognizedText == recognizedText)&&(identical(other.route, route) || other.route == route)&&(identical(other.engine, engine) || other.engine == engine)&&const DeepCollectionEquality().equals(other.warnings, warnings)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,sourceLang,targetLang,detectedLang,recognizedText,route,engine,const DeepCollectionEquality().hash(warnings),const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'TranslationResult(text: $text, sourceLang: $sourceLang, targetLang: $targetLang, detectedLang: $detectedLang, recognizedText: $recognizedText, route: $route, engine: $engine, warnings: $warnings, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $TranslationResultCopyWith<$Res>  {
  factory $TranslationResultCopyWith(TranslationResult value, $Res Function(TranslationResult) _then) = _$TranslationResultCopyWithImpl;
@useResult
$Res call({
 String text, String sourceLang, String targetLang, String? detectedLang, String? recognizedText, String route, String engine, List<String> warnings, List<TranslationStep> steps
});




}
/// @nodoc
class _$TranslationResultCopyWithImpl<$Res>
    implements $TranslationResultCopyWith<$Res> {
  _$TranslationResultCopyWithImpl(this._self, this._then);

  final TranslationResult _self;
  final $Res Function(TranslationResult) _then;

/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? sourceLang = null,Object? targetLang = null,Object? detectedLang = freezed,Object? recognizedText = freezed,Object? route = null,Object? engine = null,Object? warnings = null,Object? steps = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sourceLang: null == sourceLang ? _self.sourceLang : sourceLang // ignore: cast_nullable_to_non_nullable
as String,targetLang: null == targetLang ? _self.targetLang : targetLang // ignore: cast_nullable_to_non_nullable
as String,detectedLang: freezed == detectedLang ? _self.detectedLang : detectedLang // ignore: cast_nullable_to_non_nullable
as String?,recognizedText: freezed == recognizedText ? _self.recognizedText : recognizedText // ignore: cast_nullable_to_non_nullable
as String?,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<TranslationStep>,
  ));
}

}


/// Adds pattern-matching-related methods to [TranslationResult].
extension TranslationResultPatterns on TranslationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationResult value)  $default,){
final _that = this;
switch (_that) {
case _TranslationResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationResult value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String sourceLang,  String targetLang,  String? detectedLang,  String? recognizedText,  String route,  String engine,  List<String> warnings,  List<TranslationStep> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
return $default(_that.text,_that.sourceLang,_that.targetLang,_that.detectedLang,_that.recognizedText,_that.route,_that.engine,_that.warnings,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String sourceLang,  String targetLang,  String? detectedLang,  String? recognizedText,  String route,  String engine,  List<String> warnings,  List<TranslationStep> steps)  $default,) {final _that = this;
switch (_that) {
case _TranslationResult():
return $default(_that.text,_that.sourceLang,_that.targetLang,_that.detectedLang,_that.recognizedText,_that.route,_that.engine,_that.warnings,_that.steps);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String sourceLang,  String targetLang,  String? detectedLang,  String? recognizedText,  String route,  String engine,  List<String> warnings,  List<TranslationStep> steps)?  $default,) {final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
return $default(_that.text,_that.sourceLang,_that.targetLang,_that.detectedLang,_that.recognizedText,_that.route,_that.engine,_that.warnings,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TranslationResult implements TranslationResult {
  const _TranslationResult({required this.text, required this.sourceLang, required this.targetLang, this.detectedLang, this.recognizedText, required this.route, required this.engine, final  List<String> warnings = const [], final  List<TranslationStep> steps = const []}): _warnings = warnings,_steps = steps;
  factory _TranslationResult.fromJson(Map<String, dynamic> json) => _$TranslationResultFromJson(json);

@override final  String text;
@override final  String sourceLang;
@override final  String targetLang;
@override final  String? detectedLang;
@override final  String? recognizedText;
@override final  String route;
@override final  String engine;
 final  List<String> _warnings;
@override@JsonKey() List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

 final  List<TranslationStep> _steps;
@override@JsonKey() List<TranslationStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationResultCopyWith<_TranslationResult> get copyWith => __$TranslationResultCopyWithImpl<_TranslationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranslationResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationResult&&(identical(other.text, text) || other.text == text)&&(identical(other.sourceLang, sourceLang) || other.sourceLang == sourceLang)&&(identical(other.targetLang, targetLang) || other.targetLang == targetLang)&&(identical(other.detectedLang, detectedLang) || other.detectedLang == detectedLang)&&(identical(other.recognizedText, recognizedText) || other.recognizedText == recognizedText)&&(identical(other.route, route) || other.route == route)&&(identical(other.engine, engine) || other.engine == engine)&&const DeepCollectionEquality().equals(other._warnings, _warnings)&&const DeepCollectionEquality().equals(other._steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,sourceLang,targetLang,detectedLang,recognizedText,route,engine,const DeepCollectionEquality().hash(_warnings),const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'TranslationResult(text: $text, sourceLang: $sourceLang, targetLang: $targetLang, detectedLang: $detectedLang, recognizedText: $recognizedText, route: $route, engine: $engine, warnings: $warnings, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$TranslationResultCopyWith<$Res> implements $TranslationResultCopyWith<$Res> {
  factory _$TranslationResultCopyWith(_TranslationResult value, $Res Function(_TranslationResult) _then) = __$TranslationResultCopyWithImpl;
@override @useResult
$Res call({
 String text, String sourceLang, String targetLang, String? detectedLang, String? recognizedText, String route, String engine, List<String> warnings, List<TranslationStep> steps
});




}
/// @nodoc
class __$TranslationResultCopyWithImpl<$Res>
    implements _$TranslationResultCopyWith<$Res> {
  __$TranslationResultCopyWithImpl(this._self, this._then);

  final _TranslationResult _self;
  final $Res Function(_TranslationResult) _then;

/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? sourceLang = null,Object? targetLang = null,Object? detectedLang = freezed,Object? recognizedText = freezed,Object? route = null,Object? engine = null,Object? warnings = null,Object? steps = null,}) {
  return _then(_TranslationResult(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sourceLang: null == sourceLang ? _self.sourceLang : sourceLang // ignore: cast_nullable_to_non_nullable
as String,targetLang: null == targetLang ? _self.targetLang : targetLang // ignore: cast_nullable_to_non_nullable
as String,detectedLang: freezed == detectedLang ? _self.detectedLang : detectedLang // ignore: cast_nullable_to_non_nullable
as String?,recognizedText: freezed == recognizedText ? _self.recognizedText : recognizedText // ignore: cast_nullable_to_non_nullable
as String?,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,engine: null == engine ? _self.engine : engine // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<TranslationStep>,
  ));
}


}


/// @nodoc
mixin _$TokenPair {

 String get accessToken; String get refreshToken; String get tokenType; int get expiresIn;
/// Create a copy of TokenPair
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenPairCopyWith<TokenPair> get copyWith => _$TokenPairCopyWithImpl<TokenPair>(this as TokenPair, _$identity);

  /// Serializes this TokenPair to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenPair&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,tokenType,expiresIn);

@override
String toString() {
  return 'TokenPair(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class $TokenPairCopyWith<$Res>  {
  factory $TokenPairCopyWith(TokenPair value, $Res Function(TokenPair) _then) = _$TokenPairCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, String tokenType, int expiresIn
});




}
/// @nodoc
class _$TokenPairCopyWithImpl<$Res>
    implements $TokenPairCopyWith<$Res> {
  _$TokenPairCopyWithImpl(this._self, this._then);

  final TokenPair _self;
  final $Res Function(TokenPair) _then;

/// Create a copy of TokenPair
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? tokenType = null,Object? expiresIn = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,tokenType: null == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenPair].
extension TokenPairPatterns on TokenPair {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenPair value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenPair() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenPair value)  $default,){
final _that = this;
switch (_that) {
case _TokenPair():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenPair value)?  $default,){
final _that = this;
switch (_that) {
case _TokenPair() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  String tokenType,  int expiresIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenPair() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.tokenType,_that.expiresIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  String tokenType,  int expiresIn)  $default,) {final _that = this;
switch (_that) {
case _TokenPair():
return $default(_that.accessToken,_that.refreshToken,_that.tokenType,_that.expiresIn);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  String tokenType,  int expiresIn)?  $default,) {final _that = this;
switch (_that) {
case _TokenPair() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.tokenType,_that.expiresIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokenPair implements TokenPair {
  const _TokenPair({required this.accessToken, required this.refreshToken, required this.tokenType, required this.expiresIn});
  factory _TokenPair.fromJson(Map<String, dynamic> json) => _$TokenPairFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  String tokenType;
@override final  int expiresIn;

/// Create a copy of TokenPair
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenPairCopyWith<_TokenPair> get copyWith => __$TokenPairCopyWithImpl<_TokenPair>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenPairToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenPair&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.tokenType, tokenType) || other.tokenType == tokenType)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,tokenType,expiresIn);

@override
String toString() {
  return 'TokenPair(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class _$TokenPairCopyWith<$Res> implements $TokenPairCopyWith<$Res> {
  factory _$TokenPairCopyWith(_TokenPair value, $Res Function(_TokenPair) _then) = __$TokenPairCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, String tokenType, int expiresIn
});




}
/// @nodoc
class __$TokenPairCopyWithImpl<$Res>
    implements _$TokenPairCopyWith<$Res> {
  __$TokenPairCopyWithImpl(this._self, this._then);

  final _TokenPair _self;
  final $Res Function(_TokenPair) _then;

/// Create a copy of TokenPair
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? tokenType = null,Object? expiresIn = null,}) {
  return _then(_TokenPair(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,tokenType: null == tokenType ? _self.tokenType : tokenType // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UserProfile {

 String get id; String get email; String get displayName; String get role;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,displayName,role);

@override
String toString() {
  return 'UserProfile(id: $id, email: $email, displayName: $displayName, role: $role)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String email, String displayName, String role
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? role = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String role)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.email,_that.displayName,_that.role);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String displayName,  String role)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, required this.email, required this.displayName, required this.role});
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override final  String email;
@override final  String displayName;
@override final  String role;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,displayName,role);

@override
String toString() {
  return 'UserProfile(id: $id, email: $email, displayName: $displayName, role: $role)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String displayName, String role
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? role = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SyncSnapshot {

 List<Language> get languages; List<People> get peoples; List<HeritageItem> get heritage; List<Lesson> get lessons; List<Contribution> get approvedContributions;
/// Create a copy of SyncSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncSnapshotCopyWith<SyncSnapshot> get copyWith => _$SyncSnapshotCopyWithImpl<SyncSnapshot>(this as SyncSnapshot, _$identity);

  /// Serializes this SyncSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncSnapshot&&const DeepCollectionEquality().equals(other.languages, languages)&&const DeepCollectionEquality().equals(other.peoples, peoples)&&const DeepCollectionEquality().equals(other.heritage, heritage)&&const DeepCollectionEquality().equals(other.lessons, lessons)&&const DeepCollectionEquality().equals(other.approvedContributions, approvedContributions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(languages),const DeepCollectionEquality().hash(peoples),const DeepCollectionEquality().hash(heritage),const DeepCollectionEquality().hash(lessons),const DeepCollectionEquality().hash(approvedContributions));

@override
String toString() {
  return 'SyncSnapshot(languages: $languages, peoples: $peoples, heritage: $heritage, lessons: $lessons, approvedContributions: $approvedContributions)';
}


}

/// @nodoc
abstract mixin class $SyncSnapshotCopyWith<$Res>  {
  factory $SyncSnapshotCopyWith(SyncSnapshot value, $Res Function(SyncSnapshot) _then) = _$SyncSnapshotCopyWithImpl;
@useResult
$Res call({
 List<Language> languages, List<People> peoples, List<HeritageItem> heritage, List<Lesson> lessons, List<Contribution> approvedContributions
});




}
/// @nodoc
class _$SyncSnapshotCopyWithImpl<$Res>
    implements $SyncSnapshotCopyWith<$Res> {
  _$SyncSnapshotCopyWithImpl(this._self, this._then);

  final SyncSnapshot _self;
  final $Res Function(SyncSnapshot) _then;

/// Create a copy of SyncSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? languages = null,Object? peoples = null,Object? heritage = null,Object? lessons = null,Object? approvedContributions = null,}) {
  return _then(_self.copyWith(
languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<Language>,peoples: null == peoples ? _self.peoples : peoples // ignore: cast_nullable_to_non_nullable
as List<People>,heritage: null == heritage ? _self.heritage : heritage // ignore: cast_nullable_to_non_nullable
as List<HeritageItem>,lessons: null == lessons ? _self.lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<Lesson>,approvedContributions: null == approvedContributions ? _self.approvedContributions : approvedContributions // ignore: cast_nullable_to_non_nullable
as List<Contribution>,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncSnapshot].
extension SyncSnapshotPatterns on SyncSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _SyncSnapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _SyncSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Language> languages,  List<People> peoples,  List<HeritageItem> heritage,  List<Lesson> lessons,  List<Contribution> approvedContributions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncSnapshot() when $default != null:
return $default(_that.languages,_that.peoples,_that.heritage,_that.lessons,_that.approvedContributions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Language> languages,  List<People> peoples,  List<HeritageItem> heritage,  List<Lesson> lessons,  List<Contribution> approvedContributions)  $default,) {final _that = this;
switch (_that) {
case _SyncSnapshot():
return $default(_that.languages,_that.peoples,_that.heritage,_that.lessons,_that.approvedContributions);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Language> languages,  List<People> peoples,  List<HeritageItem> heritage,  List<Lesson> lessons,  List<Contribution> approvedContributions)?  $default,) {final _that = this;
switch (_that) {
case _SyncSnapshot() when $default != null:
return $default(_that.languages,_that.peoples,_that.heritage,_that.lessons,_that.approvedContributions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncSnapshot implements SyncSnapshot {
  const _SyncSnapshot({required final  List<Language> languages, required final  List<People> peoples, required final  List<HeritageItem> heritage, required final  List<Lesson> lessons, final  List<Contribution> approvedContributions = const []}): _languages = languages,_peoples = peoples,_heritage = heritage,_lessons = lessons,_approvedContributions = approvedContributions;
  factory _SyncSnapshot.fromJson(Map<String, dynamic> json) => _$SyncSnapshotFromJson(json);

 final  List<Language> _languages;
@override List<Language> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

 final  List<People> _peoples;
@override List<People> get peoples {
  if (_peoples is EqualUnmodifiableListView) return _peoples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_peoples);
}

 final  List<HeritageItem> _heritage;
@override List<HeritageItem> get heritage {
  if (_heritage is EqualUnmodifiableListView) return _heritage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_heritage);
}

 final  List<Lesson> _lessons;
@override List<Lesson> get lessons {
  if (_lessons is EqualUnmodifiableListView) return _lessons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lessons);
}

 final  List<Contribution> _approvedContributions;
@override@JsonKey() List<Contribution> get approvedContributions {
  if (_approvedContributions is EqualUnmodifiableListView) return _approvedContributions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_approvedContributions);
}


/// Create a copy of SyncSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncSnapshotCopyWith<_SyncSnapshot> get copyWith => __$SyncSnapshotCopyWithImpl<_SyncSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncSnapshot&&const DeepCollectionEquality().equals(other._languages, _languages)&&const DeepCollectionEquality().equals(other._peoples, _peoples)&&const DeepCollectionEquality().equals(other._heritage, _heritage)&&const DeepCollectionEquality().equals(other._lessons, _lessons)&&const DeepCollectionEquality().equals(other._approvedContributions, _approvedContributions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_languages),const DeepCollectionEquality().hash(_peoples),const DeepCollectionEquality().hash(_heritage),const DeepCollectionEquality().hash(_lessons),const DeepCollectionEquality().hash(_approvedContributions));

@override
String toString() {
  return 'SyncSnapshot(languages: $languages, peoples: $peoples, heritage: $heritage, lessons: $lessons, approvedContributions: $approvedContributions)';
}


}

/// @nodoc
abstract mixin class _$SyncSnapshotCopyWith<$Res> implements $SyncSnapshotCopyWith<$Res> {
  factory _$SyncSnapshotCopyWith(_SyncSnapshot value, $Res Function(_SyncSnapshot) _then) = __$SyncSnapshotCopyWithImpl;
@override @useResult
$Res call({
 List<Language> languages, List<People> peoples, List<HeritageItem> heritage, List<Lesson> lessons, List<Contribution> approvedContributions
});




}
/// @nodoc
class __$SyncSnapshotCopyWithImpl<$Res>
    implements _$SyncSnapshotCopyWith<$Res> {
  __$SyncSnapshotCopyWithImpl(this._self, this._then);

  final _SyncSnapshot _self;
  final $Res Function(_SyncSnapshot) _then;

/// Create a copy of SyncSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? languages = null,Object? peoples = null,Object? heritage = null,Object? lessons = null,Object? approvedContributions = null,}) {
  return _then(_SyncSnapshot(
languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<Language>,peoples: null == peoples ? _self._peoples : peoples // ignore: cast_nullable_to_non_nullable
as List<People>,heritage: null == heritage ? _self._heritage : heritage // ignore: cast_nullable_to_non_nullable
as List<HeritageItem>,lessons: null == lessons ? _self._lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<Lesson>,approvedContributions: null == approvedContributions ? _self._approvedContributions : approvedContributions // ignore: cast_nullable_to_non_nullable
as List<Contribution>,
  ));
}


}


/// @nodoc
mixin _$QuizScore {

 int get score; int get total;
/// Create a copy of QuizScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizScoreCopyWith<QuizScore> get copyWith => _$QuizScoreCopyWithImpl<QuizScore>(this as QuizScore, _$identity);

  /// Serializes this QuizScore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizScore&&(identical(other.score, score) || other.score == score)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,total);

@override
String toString() {
  return 'QuizScore(score: $score, total: $total)';
}


}

/// @nodoc
abstract mixin class $QuizScoreCopyWith<$Res>  {
  factory $QuizScoreCopyWith(QuizScore value, $Res Function(QuizScore) _then) = _$QuizScoreCopyWithImpl;
@useResult
$Res call({
 int score, int total
});




}
/// @nodoc
class _$QuizScoreCopyWithImpl<$Res>
    implements $QuizScoreCopyWith<$Res> {
  _$QuizScoreCopyWithImpl(this._self, this._then);

  final QuizScore _self;
  final $Res Function(QuizScore) _then;

/// Create a copy of QuizScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? total = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizScore].
extension QuizScorePatterns on QuizScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizScore value)  $default,){
final _that = this;
switch (_that) {
case _QuizScore():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizScore value)?  $default,){
final _that = this;
switch (_that) {
case _QuizScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int score,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizScore() when $default != null:
return $default(_that.score,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int score,  int total)  $default,) {final _that = this;
switch (_that) {
case _QuizScore():
return $default(_that.score,_that.total);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int score,  int total)?  $default,) {final _that = this;
switch (_that) {
case _QuizScore() when $default != null:
return $default(_that.score,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizScore implements QuizScore {
  const _QuizScore({required this.score, required this.total});
  factory _QuizScore.fromJson(Map<String, dynamic> json) => _$QuizScoreFromJson(json);

@override final  int score;
@override final  int total;

/// Create a copy of QuizScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizScoreCopyWith<_QuizScore> get copyWith => __$QuizScoreCopyWithImpl<_QuizScore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizScoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizScore&&(identical(other.score, score) || other.score == score)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,total);

@override
String toString() {
  return 'QuizScore(score: $score, total: $total)';
}


}

/// @nodoc
abstract mixin class _$QuizScoreCopyWith<$Res> implements $QuizScoreCopyWith<$Res> {
  factory _$QuizScoreCopyWith(_QuizScore value, $Res Function(_QuizScore) _then) = __$QuizScoreCopyWithImpl;
@override @useResult
$Res call({
 int score, int total
});




}
/// @nodoc
class __$QuizScoreCopyWithImpl<$Res>
    implements _$QuizScoreCopyWith<$Res> {
  __$QuizScoreCopyWithImpl(this._self, this._then);

  final _QuizScore _self;
  final $Res Function(_QuizScore) _then;

/// Create a copy of QuizScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? total = null,}) {
  return _then(_QuizScore(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
