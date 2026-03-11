// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_to_speech_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TextToSpeechEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TextToSpeechEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TextToSpeechEvent()';
  }
}

/// @nodoc
class $TextToSpeechEventCopyWith<$Res> {
  $TextToSpeechEventCopyWith(
      TextToSpeechEvent _, $Res Function(TextToSpeechEvent) __);
}

/// @nodoc

class SpeechToTextStarted implements TextToSpeechEvent {
  const SpeechToTextStarted({required this.text});

  final String text;

  /// Create a copy of TextToSpeechEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpeechToTextStartedCopyWith<SpeechToTextStarted> get copyWith =>
      _$SpeechToTextStartedCopyWithImpl<SpeechToTextStarted>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SpeechToTextStarted &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  @override
  String toString() {
    return 'TextToSpeechEvent.started(text: $text)';
  }
}

/// @nodoc
abstract mixin class $SpeechToTextStartedCopyWith<$Res>
    implements $TextToSpeechEventCopyWith<$Res> {
  factory $SpeechToTextStartedCopyWith(
          SpeechToTextStarted value, $Res Function(SpeechToTextStarted) _then) =
      _$SpeechToTextStartedCopyWithImpl;
  @useResult
  $Res call({String text});
}

/// @nodoc
class _$SpeechToTextStartedCopyWithImpl<$Res>
    implements $SpeechToTextStartedCopyWith<$Res> {
  _$SpeechToTextStartedCopyWithImpl(this._self, this._then);

  final SpeechToTextStarted _self;
  final $Res Function(SpeechToTextStarted) _then;

  /// Create a copy of TextToSpeechEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? text = null,
  }) {
    return _then(SpeechToTextStarted(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class SpeechToTextStopped implements TextToSpeechEvent {
  const SpeechToTextStopped();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SpeechToTextStopped);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TextToSpeechEvent.stopped()';
  }
}

/// @nodoc
mixin _$TextToSpeechState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TextToSpeechState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TextToSpeechState()';
  }
}

/// @nodoc
class $TextToSpeechStateCopyWith<$Res> {
  $TextToSpeechStateCopyWith(
      TextToSpeechState _, $Res Function(TextToSpeechState) __);
}

/// @nodoc

class _Initial implements TextToSpeechState {
  const _Initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TextToSpeechState.initial()';
  }
}

/// @nodoc

class _SpeechPlaying implements TextToSpeechState {
  const _SpeechPlaying();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _SpeechPlaying);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TextToSpeechState.playing()';
  }
}

/// @nodoc

class _Completed implements TextToSpeechState {
  const _Completed();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Completed);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TextToSpeechState.completed()';
  }
}

/// @nodoc

class _SpeechError implements TextToSpeechState {
  const _SpeechError({required this.message});

  final String message;

  /// Create a copy of TextToSpeechState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SpeechErrorCopyWith<_SpeechError> get copyWith =>
      __$SpeechErrorCopyWithImpl<_SpeechError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SpeechError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'TextToSpeechState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$SpeechErrorCopyWith<$Res>
    implements $TextToSpeechStateCopyWith<$Res> {
  factory _$SpeechErrorCopyWith(
          _SpeechError value, $Res Function(_SpeechError) _then) =
      __$SpeechErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$SpeechErrorCopyWithImpl<$Res> implements _$SpeechErrorCopyWith<$Res> {
  __$SpeechErrorCopyWithImpl(this._self, this._then);

  final _SpeechError _self;
  final $Res Function(_SpeechError) _then;

  /// Create a copy of TextToSpeechState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_SpeechError(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
