// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoenixLevelMeta = const VerificationMeta(
    'phoenixLevel',
  );
  @override
  late final GeneratedColumn<int> phoenixLevel = GeneratedColumn<int>(
    'phoenix_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _musclesPrimaryMeta = const VerificationMeta(
    'musclesPrimary',
  );
  @override
  late final GeneratedColumn<String> musclesPrimary = GeneratedColumn<String>(
    'muscles_primary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _musclesSecondaryMeta = const VerificationMeta(
    'musclesSecondary',
  );
  @override
  late final GeneratedColumn<String> musclesSecondary = GeneratedColumn<String>(
    'muscles_secondary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imagePathsMeta = const VerificationMeta(
    'imagePaths',
  );
  @override
  late final GeneratedColumn<String> imagePaths = GeneratedColumn<String>(
    'image_paths',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _animationPathMeta = const VerificationMeta(
    'animationPath',
  );
  @override
  late final GeneratedColumn<String> animationPath = GeneratedColumn<String>(
    'animation_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _progressionNextIdMeta = const VerificationMeta(
    'progressionNextId',
  );
  @override
  late final GeneratedColumn<int> progressionNextId = GeneratedColumn<int>(
    'progression_next_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressionPrevIdMeta = const VerificationMeta(
    'progressionPrevId',
  );
  @override
  late final GeneratedColumn<int> progressionPrevId = GeneratedColumn<int>(
    'progression_prev_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _advancementCriteriaMeta =
      const VerificationMeta('advancementCriteria');
  @override
  late final GeneratedColumn<String> advancementCriteria =
      GeneratedColumn<String>(
        'advancement_criteria',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('all'),
  );
  static const VerificationMeta _executionCuesMeta = const VerificationMeta(
    'executionCues',
  );
  @override
  late final GeneratedColumn<String> executionCues = GeneratedColumn<String>(
    'execution_cues',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _defaultSetsMeta = const VerificationMeta(
    'defaultSets',
  );
  @override
  late final GeneratedColumn<int> defaultSets = GeneratedColumn<int>(
    'default_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _defaultRepsMinMeta = const VerificationMeta(
    'defaultRepsMin',
  );
  @override
  late final GeneratedColumn<int> defaultRepsMin = GeneratedColumn<int>(
    'default_reps_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _defaultRepsMaxMeta = const VerificationMeta(
    'defaultRepsMax',
  );
  @override
  late final GeneratedColumn<int> defaultRepsMax = GeneratedColumn<int>(
    'default_reps_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _defaultTempoEccMeta = const VerificationMeta(
    'defaultTempoEcc',
  );
  @override
  late final GeneratedColumn<int> defaultTempoEcc = GeneratedColumn<int>(
    'default_tempo_ecc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _defaultTempoConMeta = const VerificationMeta(
    'defaultTempoCon',
  );
  @override
  late final GeneratedColumn<int> defaultTempoCon = GeneratedColumn<int>(
    'default_tempo_con',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _dayTypeMeta = const VerificationMeta(
    'dayType',
  );
  @override
  late final GeneratedColumn<String> dayType = GeneratedColumn<String>(
    'day_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _exerciseTypeMeta = const VerificationMeta(
    'exerciseType',
  );
  @override
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
    'exercise_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('compound'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    phoenixLevel,
    musclesPrimary,
    musclesSecondary,
    instructions,
    imagePaths,
    animationPath,
    progressionNextId,
    progressionPrevId,
    advancementCriteria,
    equipment,
    executionCues,
    defaultSets,
    defaultRepsMin,
    defaultRepsMax,
    defaultTempoEcc,
    defaultTempoCon,
    dayType,
    exerciseType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('phoenix_level')) {
      context.handle(
        _phoenixLevelMeta,
        phoenixLevel.isAcceptableOrUnknown(
          data['phoenix_level']!,
          _phoenixLevelMeta,
        ),
      );
    }
    if (data.containsKey('muscles_primary')) {
      context.handle(
        _musclesPrimaryMeta,
        musclesPrimary.isAcceptableOrUnknown(
          data['muscles_primary']!,
          _musclesPrimaryMeta,
        ),
      );
    }
    if (data.containsKey('muscles_secondary')) {
      context.handle(
        _musclesSecondaryMeta,
        musclesSecondary.isAcceptableOrUnknown(
          data['muscles_secondary']!,
          _musclesSecondaryMeta,
        ),
      );
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('image_paths')) {
      context.handle(
        _imagePathsMeta,
        imagePaths.isAcceptableOrUnknown(data['image_paths']!, _imagePathsMeta),
      );
    }
    if (data.containsKey('animation_path')) {
      context.handle(
        _animationPathMeta,
        animationPath.isAcceptableOrUnknown(
          data['animation_path']!,
          _animationPathMeta,
        ),
      );
    }
    if (data.containsKey('progression_next_id')) {
      context.handle(
        _progressionNextIdMeta,
        progressionNextId.isAcceptableOrUnknown(
          data['progression_next_id']!,
          _progressionNextIdMeta,
        ),
      );
    }
    if (data.containsKey('progression_prev_id')) {
      context.handle(
        _progressionPrevIdMeta,
        progressionPrevId.isAcceptableOrUnknown(
          data['progression_prev_id']!,
          _progressionPrevIdMeta,
        ),
      );
    }
    if (data.containsKey('advancement_criteria')) {
      context.handle(
        _advancementCriteriaMeta,
        advancementCriteria.isAcceptableOrUnknown(
          data['advancement_criteria']!,
          _advancementCriteriaMeta,
        ),
      );
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    }
    if (data.containsKey('execution_cues')) {
      context.handle(
        _executionCuesMeta,
        executionCues.isAcceptableOrUnknown(
          data['execution_cues']!,
          _executionCuesMeta,
        ),
      );
    }
    if (data.containsKey('default_sets')) {
      context.handle(
        _defaultSetsMeta,
        defaultSets.isAcceptableOrUnknown(
          data['default_sets']!,
          _defaultSetsMeta,
        ),
      );
    }
    if (data.containsKey('default_reps_min')) {
      context.handle(
        _defaultRepsMinMeta,
        defaultRepsMin.isAcceptableOrUnknown(
          data['default_reps_min']!,
          _defaultRepsMinMeta,
        ),
      );
    }
    if (data.containsKey('default_reps_max')) {
      context.handle(
        _defaultRepsMaxMeta,
        defaultRepsMax.isAcceptableOrUnknown(
          data['default_reps_max']!,
          _defaultRepsMaxMeta,
        ),
      );
    }
    if (data.containsKey('default_tempo_ecc')) {
      context.handle(
        _defaultTempoEccMeta,
        defaultTempoEcc.isAcceptableOrUnknown(
          data['default_tempo_ecc']!,
          _defaultTempoEccMeta,
        ),
      );
    }
    if (data.containsKey('default_tempo_con')) {
      context.handle(
        _defaultTempoConMeta,
        defaultTempoCon.isAcceptableOrUnknown(
          data['default_tempo_con']!,
          _defaultTempoConMeta,
        ),
      );
    }
    if (data.containsKey('day_type')) {
      context.handle(
        _dayTypeMeta,
        dayType.isAcceptableOrUnknown(data['day_type']!, _dayTypeMeta),
      );
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
        _exerciseTypeMeta,
        exerciseType.isAcceptableOrUnknown(
          data['exercise_type']!,
          _exerciseTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      category:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}category'],
          )!,
      phoenixLevel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}phoenix_level'],
          )!,
      musclesPrimary:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}muscles_primary'],
          )!,
      musclesSecondary:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}muscles_secondary'],
          )!,
      instructions:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}instructions'],
          )!,
      imagePaths:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}image_paths'],
          )!,
      animationPath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}animation_path'],
          )!,
      progressionNextId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progression_next_id'],
      ),
      progressionPrevId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progression_prev_id'],
      ),
      advancementCriteria:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}advancement_criteria'],
          )!,
      equipment:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}equipment'],
          )!,
      executionCues:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}execution_cues'],
          )!,
      defaultSets:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}default_sets'],
          )!,
      defaultRepsMin:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}default_reps_min'],
          )!,
      defaultRepsMax:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}default_reps_max'],
          )!,
      defaultTempoEcc:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}default_tempo_ecc'],
          )!,
      defaultTempoCon:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}default_tempo_con'],
          )!,
      dayType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}day_type'],
          )!,
      exerciseType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}exercise_type'],
          )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final String category;
  final int phoenixLevel;
  final String musclesPrimary;
  final String musclesSecondary;
  final String instructions;
  final String imagePaths;
  final String animationPath;
  final int? progressionNextId;
  final int? progressionPrevId;
  final String advancementCriteria;
  final String equipment;
  final String executionCues;
  final int defaultSets;
  final int defaultRepsMin;
  final int defaultRepsMax;
  final int defaultTempoEcc;
  final int defaultTempoCon;
  final String dayType;
  final String exerciseType;
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.phoenixLevel,
    required this.musclesPrimary,
    required this.musclesSecondary,
    required this.instructions,
    required this.imagePaths,
    required this.animationPath,
    this.progressionNextId,
    this.progressionPrevId,
    required this.advancementCriteria,
    required this.equipment,
    required this.executionCues,
    required this.defaultSets,
    required this.defaultRepsMin,
    required this.defaultRepsMax,
    required this.defaultTempoEcc,
    required this.defaultTempoCon,
    required this.dayType,
    required this.exerciseType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['phoenix_level'] = Variable<int>(phoenixLevel);
    map['muscles_primary'] = Variable<String>(musclesPrimary);
    map['muscles_secondary'] = Variable<String>(musclesSecondary);
    map['instructions'] = Variable<String>(instructions);
    map['image_paths'] = Variable<String>(imagePaths);
    map['animation_path'] = Variable<String>(animationPath);
    if (!nullToAbsent || progressionNextId != null) {
      map['progression_next_id'] = Variable<int>(progressionNextId);
    }
    if (!nullToAbsent || progressionPrevId != null) {
      map['progression_prev_id'] = Variable<int>(progressionPrevId);
    }
    map['advancement_criteria'] = Variable<String>(advancementCriteria);
    map['equipment'] = Variable<String>(equipment);
    map['execution_cues'] = Variable<String>(executionCues);
    map['default_sets'] = Variable<int>(defaultSets);
    map['default_reps_min'] = Variable<int>(defaultRepsMin);
    map['default_reps_max'] = Variable<int>(defaultRepsMax);
    map['default_tempo_ecc'] = Variable<int>(defaultTempoEcc);
    map['default_tempo_con'] = Variable<int>(defaultTempoCon);
    map['day_type'] = Variable<String>(dayType);
    map['exercise_type'] = Variable<String>(exerciseType);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      phoenixLevel: Value(phoenixLevel),
      musclesPrimary: Value(musclesPrimary),
      musclesSecondary: Value(musclesSecondary),
      instructions: Value(instructions),
      imagePaths: Value(imagePaths),
      animationPath: Value(animationPath),
      progressionNextId:
          progressionNextId == null && nullToAbsent
              ? const Value.absent()
              : Value(progressionNextId),
      progressionPrevId:
          progressionPrevId == null && nullToAbsent
              ? const Value.absent()
              : Value(progressionPrevId),
      advancementCriteria: Value(advancementCriteria),
      equipment: Value(equipment),
      executionCues: Value(executionCues),
      defaultSets: Value(defaultSets),
      defaultRepsMin: Value(defaultRepsMin),
      defaultRepsMax: Value(defaultRepsMax),
      defaultTempoEcc: Value(defaultTempoEcc),
      defaultTempoCon: Value(defaultTempoCon),
      dayType: Value(dayType),
      exerciseType: Value(exerciseType),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      phoenixLevel: serializer.fromJson<int>(json['phoenixLevel']),
      musclesPrimary: serializer.fromJson<String>(json['musclesPrimary']),
      musclesSecondary: serializer.fromJson<String>(json['musclesSecondary']),
      instructions: serializer.fromJson<String>(json['instructions']),
      imagePaths: serializer.fromJson<String>(json['imagePaths']),
      animationPath: serializer.fromJson<String>(json['animationPath']),
      progressionNextId: serializer.fromJson<int?>(json['progressionNextId']),
      progressionPrevId: serializer.fromJson<int?>(json['progressionPrevId']),
      advancementCriteria: serializer.fromJson<String>(
        json['advancementCriteria'],
      ),
      equipment: serializer.fromJson<String>(json['equipment']),
      executionCues: serializer.fromJson<String>(json['executionCues']),
      defaultSets: serializer.fromJson<int>(json['defaultSets']),
      defaultRepsMin: serializer.fromJson<int>(json['defaultRepsMin']),
      defaultRepsMax: serializer.fromJson<int>(json['defaultRepsMax']),
      defaultTempoEcc: serializer.fromJson<int>(json['defaultTempoEcc']),
      defaultTempoCon: serializer.fromJson<int>(json['defaultTempoCon']),
      dayType: serializer.fromJson<String>(json['dayType']),
      exerciseType: serializer.fromJson<String>(json['exerciseType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'phoenixLevel': serializer.toJson<int>(phoenixLevel),
      'musclesPrimary': serializer.toJson<String>(musclesPrimary),
      'musclesSecondary': serializer.toJson<String>(musclesSecondary),
      'instructions': serializer.toJson<String>(instructions),
      'imagePaths': serializer.toJson<String>(imagePaths),
      'animationPath': serializer.toJson<String>(animationPath),
      'progressionNextId': serializer.toJson<int?>(progressionNextId),
      'progressionPrevId': serializer.toJson<int?>(progressionPrevId),
      'advancementCriteria': serializer.toJson<String>(advancementCriteria),
      'equipment': serializer.toJson<String>(equipment),
      'executionCues': serializer.toJson<String>(executionCues),
      'defaultSets': serializer.toJson<int>(defaultSets),
      'defaultRepsMin': serializer.toJson<int>(defaultRepsMin),
      'defaultRepsMax': serializer.toJson<int>(defaultRepsMax),
      'defaultTempoEcc': serializer.toJson<int>(defaultTempoEcc),
      'defaultTempoCon': serializer.toJson<int>(defaultTempoCon),
      'dayType': serializer.toJson<String>(dayType),
      'exerciseType': serializer.toJson<String>(exerciseType),
    };
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? category,
    int? phoenixLevel,
    String? musclesPrimary,
    String? musclesSecondary,
    String? instructions,
    String? imagePaths,
    String? animationPath,
    Value<int?> progressionNextId = const Value.absent(),
    Value<int?> progressionPrevId = const Value.absent(),
    String? advancementCriteria,
    String? equipment,
    String? executionCues,
    int? defaultSets,
    int? defaultRepsMin,
    int? defaultRepsMax,
    int? defaultTempoEcc,
    int? defaultTempoCon,
    String? dayType,
    String? exerciseType,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    phoenixLevel: phoenixLevel ?? this.phoenixLevel,
    musclesPrimary: musclesPrimary ?? this.musclesPrimary,
    musclesSecondary: musclesSecondary ?? this.musclesSecondary,
    instructions: instructions ?? this.instructions,
    imagePaths: imagePaths ?? this.imagePaths,
    animationPath: animationPath ?? this.animationPath,
    progressionNextId:
        progressionNextId.present
            ? progressionNextId.value
            : this.progressionNextId,
    progressionPrevId:
        progressionPrevId.present
            ? progressionPrevId.value
            : this.progressionPrevId,
    advancementCriteria: advancementCriteria ?? this.advancementCriteria,
    equipment: equipment ?? this.equipment,
    executionCues: executionCues ?? this.executionCues,
    defaultSets: defaultSets ?? this.defaultSets,
    defaultRepsMin: defaultRepsMin ?? this.defaultRepsMin,
    defaultRepsMax: defaultRepsMax ?? this.defaultRepsMax,
    defaultTempoEcc: defaultTempoEcc ?? this.defaultTempoEcc,
    defaultTempoCon: defaultTempoCon ?? this.defaultTempoCon,
    dayType: dayType ?? this.dayType,
    exerciseType: exerciseType ?? this.exerciseType,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      phoenixLevel:
          data.phoenixLevel.present
              ? data.phoenixLevel.value
              : this.phoenixLevel,
      musclesPrimary:
          data.musclesPrimary.present
              ? data.musclesPrimary.value
              : this.musclesPrimary,
      musclesSecondary:
          data.musclesSecondary.present
              ? data.musclesSecondary.value
              : this.musclesSecondary,
      instructions:
          data.instructions.present
              ? data.instructions.value
              : this.instructions,
      imagePaths:
          data.imagePaths.present ? data.imagePaths.value : this.imagePaths,
      animationPath:
          data.animationPath.present
              ? data.animationPath.value
              : this.animationPath,
      progressionNextId:
          data.progressionNextId.present
              ? data.progressionNextId.value
              : this.progressionNextId,
      progressionPrevId:
          data.progressionPrevId.present
              ? data.progressionPrevId.value
              : this.progressionPrevId,
      advancementCriteria:
          data.advancementCriteria.present
              ? data.advancementCriteria.value
              : this.advancementCriteria,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      executionCues:
          data.executionCues.present
              ? data.executionCues.value
              : this.executionCues,
      defaultSets:
          data.defaultSets.present ? data.defaultSets.value : this.defaultSets,
      defaultRepsMin:
          data.defaultRepsMin.present
              ? data.defaultRepsMin.value
              : this.defaultRepsMin,
      defaultRepsMax:
          data.defaultRepsMax.present
              ? data.defaultRepsMax.value
              : this.defaultRepsMax,
      defaultTempoEcc:
          data.defaultTempoEcc.present
              ? data.defaultTempoEcc.value
              : this.defaultTempoEcc,
      defaultTempoCon:
          data.defaultTempoCon.present
              ? data.defaultTempoCon.value
              : this.defaultTempoCon,
      dayType: data.dayType.present ? data.dayType.value : this.dayType,
      exerciseType:
          data.exerciseType.present
              ? data.exerciseType.value
              : this.exerciseType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('phoenixLevel: $phoenixLevel, ')
          ..write('musclesPrimary: $musclesPrimary, ')
          ..write('musclesSecondary: $musclesSecondary, ')
          ..write('instructions: $instructions, ')
          ..write('imagePaths: $imagePaths, ')
          ..write('animationPath: $animationPath, ')
          ..write('progressionNextId: $progressionNextId, ')
          ..write('progressionPrevId: $progressionPrevId, ')
          ..write('advancementCriteria: $advancementCriteria, ')
          ..write('equipment: $equipment, ')
          ..write('executionCues: $executionCues, ')
          ..write('defaultSets: $defaultSets, ')
          ..write('defaultRepsMin: $defaultRepsMin, ')
          ..write('defaultRepsMax: $defaultRepsMax, ')
          ..write('defaultTempoEcc: $defaultTempoEcc, ')
          ..write('defaultTempoCon: $defaultTempoCon, ')
          ..write('dayType: $dayType, ')
          ..write('exerciseType: $exerciseType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    category,
    phoenixLevel,
    musclesPrimary,
    musclesSecondary,
    instructions,
    imagePaths,
    animationPath,
    progressionNextId,
    progressionPrevId,
    advancementCriteria,
    equipment,
    executionCues,
    defaultSets,
    defaultRepsMin,
    defaultRepsMax,
    defaultTempoEcc,
    defaultTempoCon,
    dayType,
    exerciseType,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.phoenixLevel == this.phoenixLevel &&
          other.musclesPrimary == this.musclesPrimary &&
          other.musclesSecondary == this.musclesSecondary &&
          other.instructions == this.instructions &&
          other.imagePaths == this.imagePaths &&
          other.animationPath == this.animationPath &&
          other.progressionNextId == this.progressionNextId &&
          other.progressionPrevId == this.progressionPrevId &&
          other.advancementCriteria == this.advancementCriteria &&
          other.equipment == this.equipment &&
          other.executionCues == this.executionCues &&
          other.defaultSets == this.defaultSets &&
          other.defaultRepsMin == this.defaultRepsMin &&
          other.defaultRepsMax == this.defaultRepsMax &&
          other.defaultTempoEcc == this.defaultTempoEcc &&
          other.defaultTempoCon == this.defaultTempoCon &&
          other.dayType == this.dayType &&
          other.exerciseType == this.exerciseType);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> phoenixLevel;
  final Value<String> musclesPrimary;
  final Value<String> musclesSecondary;
  final Value<String> instructions;
  final Value<String> imagePaths;
  final Value<String> animationPath;
  final Value<int?> progressionNextId;
  final Value<int?> progressionPrevId;
  final Value<String> advancementCriteria;
  final Value<String> equipment;
  final Value<String> executionCues;
  final Value<int> defaultSets;
  final Value<int> defaultRepsMin;
  final Value<int> defaultRepsMax;
  final Value<int> defaultTempoEcc;
  final Value<int> defaultTempoCon;
  final Value<String> dayType;
  final Value<String> exerciseType;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.phoenixLevel = const Value.absent(),
    this.musclesPrimary = const Value.absent(),
    this.musclesSecondary = const Value.absent(),
    this.instructions = const Value.absent(),
    this.imagePaths = const Value.absent(),
    this.animationPath = const Value.absent(),
    this.progressionNextId = const Value.absent(),
    this.progressionPrevId = const Value.absent(),
    this.advancementCriteria = const Value.absent(),
    this.equipment = const Value.absent(),
    this.executionCues = const Value.absent(),
    this.defaultSets = const Value.absent(),
    this.defaultRepsMin = const Value.absent(),
    this.defaultRepsMax = const Value.absent(),
    this.defaultTempoEcc = const Value.absent(),
    this.defaultTempoCon = const Value.absent(),
    this.dayType = const Value.absent(),
    this.exerciseType = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    this.phoenixLevel = const Value.absent(),
    this.musclesPrimary = const Value.absent(),
    this.musclesSecondary = const Value.absent(),
    this.instructions = const Value.absent(),
    this.imagePaths = const Value.absent(),
    this.animationPath = const Value.absent(),
    this.progressionNextId = const Value.absent(),
    this.progressionPrevId = const Value.absent(),
    this.advancementCriteria = const Value.absent(),
    this.equipment = const Value.absent(),
    this.executionCues = const Value.absent(),
    this.defaultSets = const Value.absent(),
    this.defaultRepsMin = const Value.absent(),
    this.defaultRepsMax = const Value.absent(),
    this.defaultTempoEcc = const Value.absent(),
    this.defaultTempoCon = const Value.absent(),
    this.dayType = const Value.absent(),
    this.exerciseType = const Value.absent(),
  }) : name = Value(name),
       category = Value(category);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? phoenixLevel,
    Expression<String>? musclesPrimary,
    Expression<String>? musclesSecondary,
    Expression<String>? instructions,
    Expression<String>? imagePaths,
    Expression<String>? animationPath,
    Expression<int>? progressionNextId,
    Expression<int>? progressionPrevId,
    Expression<String>? advancementCriteria,
    Expression<String>? equipment,
    Expression<String>? executionCues,
    Expression<int>? defaultSets,
    Expression<int>? defaultRepsMin,
    Expression<int>? defaultRepsMax,
    Expression<int>? defaultTempoEcc,
    Expression<int>? defaultTempoCon,
    Expression<String>? dayType,
    Expression<String>? exerciseType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (phoenixLevel != null) 'phoenix_level': phoenixLevel,
      if (musclesPrimary != null) 'muscles_primary': musclesPrimary,
      if (musclesSecondary != null) 'muscles_secondary': musclesSecondary,
      if (instructions != null) 'instructions': instructions,
      if (imagePaths != null) 'image_paths': imagePaths,
      if (animationPath != null) 'animation_path': animationPath,
      if (progressionNextId != null) 'progression_next_id': progressionNextId,
      if (progressionPrevId != null) 'progression_prev_id': progressionPrevId,
      if (advancementCriteria != null)
        'advancement_criteria': advancementCriteria,
      if (equipment != null) 'equipment': equipment,
      if (executionCues != null) 'execution_cues': executionCues,
      if (defaultSets != null) 'default_sets': defaultSets,
      if (defaultRepsMin != null) 'default_reps_min': defaultRepsMin,
      if (defaultRepsMax != null) 'default_reps_max': defaultRepsMax,
      if (defaultTempoEcc != null) 'default_tempo_ecc': defaultTempoEcc,
      if (defaultTempoCon != null) 'default_tempo_con': defaultTempoCon,
      if (dayType != null) 'day_type': dayType,
      if (exerciseType != null) 'exercise_type': exerciseType,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? category,
    Value<int>? phoenixLevel,
    Value<String>? musclesPrimary,
    Value<String>? musclesSecondary,
    Value<String>? instructions,
    Value<String>? imagePaths,
    Value<String>? animationPath,
    Value<int?>? progressionNextId,
    Value<int?>? progressionPrevId,
    Value<String>? advancementCriteria,
    Value<String>? equipment,
    Value<String>? executionCues,
    Value<int>? defaultSets,
    Value<int>? defaultRepsMin,
    Value<int>? defaultRepsMax,
    Value<int>? defaultTempoEcc,
    Value<int>? defaultTempoCon,
    Value<String>? dayType,
    Value<String>? exerciseType,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      phoenixLevel: phoenixLevel ?? this.phoenixLevel,
      musclesPrimary: musclesPrimary ?? this.musclesPrimary,
      musclesSecondary: musclesSecondary ?? this.musclesSecondary,
      instructions: instructions ?? this.instructions,
      imagePaths: imagePaths ?? this.imagePaths,
      animationPath: animationPath ?? this.animationPath,
      progressionNextId: progressionNextId ?? this.progressionNextId,
      progressionPrevId: progressionPrevId ?? this.progressionPrevId,
      advancementCriteria: advancementCriteria ?? this.advancementCriteria,
      equipment: equipment ?? this.equipment,
      executionCues: executionCues ?? this.executionCues,
      defaultSets: defaultSets ?? this.defaultSets,
      defaultRepsMin: defaultRepsMin ?? this.defaultRepsMin,
      defaultRepsMax: defaultRepsMax ?? this.defaultRepsMax,
      defaultTempoEcc: defaultTempoEcc ?? this.defaultTempoEcc,
      defaultTempoCon: defaultTempoCon ?? this.defaultTempoCon,
      dayType: dayType ?? this.dayType,
      exerciseType: exerciseType ?? this.exerciseType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (phoenixLevel.present) {
      map['phoenix_level'] = Variable<int>(phoenixLevel.value);
    }
    if (musclesPrimary.present) {
      map['muscles_primary'] = Variable<String>(musclesPrimary.value);
    }
    if (musclesSecondary.present) {
      map['muscles_secondary'] = Variable<String>(musclesSecondary.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (imagePaths.present) {
      map['image_paths'] = Variable<String>(imagePaths.value);
    }
    if (animationPath.present) {
      map['animation_path'] = Variable<String>(animationPath.value);
    }
    if (progressionNextId.present) {
      map['progression_next_id'] = Variable<int>(progressionNextId.value);
    }
    if (progressionPrevId.present) {
      map['progression_prev_id'] = Variable<int>(progressionPrevId.value);
    }
    if (advancementCriteria.present) {
      map['advancement_criteria'] = Variable<String>(advancementCriteria.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (executionCues.present) {
      map['execution_cues'] = Variable<String>(executionCues.value);
    }
    if (defaultSets.present) {
      map['default_sets'] = Variable<int>(defaultSets.value);
    }
    if (defaultRepsMin.present) {
      map['default_reps_min'] = Variable<int>(defaultRepsMin.value);
    }
    if (defaultRepsMax.present) {
      map['default_reps_max'] = Variable<int>(defaultRepsMax.value);
    }
    if (defaultTempoEcc.present) {
      map['default_tempo_ecc'] = Variable<int>(defaultTempoEcc.value);
    }
    if (defaultTempoCon.present) {
      map['default_tempo_con'] = Variable<int>(defaultTempoCon.value);
    }
    if (dayType.present) {
      map['day_type'] = Variable<String>(dayType.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('phoenixLevel: $phoenixLevel, ')
          ..write('musclesPrimary: $musclesPrimary, ')
          ..write('musclesSecondary: $musclesSecondary, ')
          ..write('instructions: $instructions, ')
          ..write('imagePaths: $imagePaths, ')
          ..write('animationPath: $animationPath, ')
          ..write('progressionNextId: $progressionNextId, ')
          ..write('progressionPrevId: $progressionPrevId, ')
          ..write('advancementCriteria: $advancementCriteria, ')
          ..write('equipment: $equipment, ')
          ..write('executionCues: $executionCues, ')
          ..write('defaultSets: $defaultSets, ')
          ..write('defaultRepsMin: $defaultRepsMin, ')
          ..write('defaultRepsMax: $defaultRepsMax, ')
          ..write('defaultTempoEcc: $defaultTempoEcc, ')
          ..write('defaultTempoCon: $defaultTempoCon, ')
          ..write('dayType: $dayType, ')
          ..write('exerciseType: $exerciseType')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<double> durationMinutes = GeneratedColumn<double>(
    'duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationScoreMeta = const VerificationMeta(
    'durationScore',
  );
  @override
  late final GeneratedColumn<String> durationScore = GeneratedColumn<String>(
    'duration_score',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpeAverageMeta = const VerificationMeta(
    'rpeAverage',
  );
  @override
  late final GeneratedColumn<double> rpeAverage = GeneratedColumn<double>(
    'rpe_average',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _llmSummaryTextMeta = const VerificationMeta(
    'llmSummaryText',
  );
  @override
  late final GeneratedColumn<String> llmSummaryText = GeneratedColumn<String>(
    'llm_summary_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _warmupCompletedMeta = const VerificationMeta(
    'warmupCompleted',
  );
  @override
  late final GeneratedColumn<bool> warmupCompleted = GeneratedColumn<bool>(
    'warmup_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("warmup_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _stabilityCompletedMeta =
      const VerificationMeta('stabilityCompleted');
  @override
  late final GeneratedColumn<bool> stabilityCompleted = GeneratedColumn<bool>(
    'stability_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("stability_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cooldownCompletedMeta = const VerificationMeta(
    'cooldownCompleted',
  );
  @override
  late final GeneratedColumn<bool> cooldownCompleted = GeneratedColumn<bool>(
    'cooldown_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cooldown_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cooldownTypeMeta = const VerificationMeta(
    'cooldownType',
  );
  @override
  late final GeneratedColumn<String> cooldownType = GeneratedColumn<String>(
    'cooldown_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgHrMeta = const VerificationMeta('avgHr');
  @override
  late final GeneratedColumn<double> avgHr = GeneratedColumn<double>(
    'avg_hr',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxHrMeta = const VerificationMeta('maxHr');
  @override
  late final GeneratedColumn<int> maxHr = GeneratedColumn<int>(
    'max_hr',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgSpo2Meta = const VerificationMeta(
    'avgSpo2',
  );
  @override
  late final GeneratedColumn<double> avgSpo2 = GeneratedColumn<double>(
    'avg_spo2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgRmssdMeta = const VerificationMeta(
    'avgRmssd',
  );
  @override
  late final GeneratedColumn<double> avgRmssd = GeneratedColumn<double>(
    'avg_rmssd',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bioStatsJsonMeta = const VerificationMeta(
    'bioStatsJson',
  );
  @override
  late final GeneratedColumn<String> bioStatsJson = GeneratedColumn<String>(
    'bio_stats_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    endedAt,
    type,
    durationMinutes,
    durationScore,
    rpeAverage,
    notes,
    llmSummaryText,
    warmupCompleted,
    stabilityCompleted,
    cooldownCompleted,
    cooldownType,
    avgHr,
    maxHr,
    avgSpo2,
    avgRmssd,
    bioStatsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('duration_score')) {
      context.handle(
        _durationScoreMeta,
        durationScore.isAcceptableOrUnknown(
          data['duration_score']!,
          _durationScoreMeta,
        ),
      );
    }
    if (data.containsKey('rpe_average')) {
      context.handle(
        _rpeAverageMeta,
        rpeAverage.isAcceptableOrUnknown(data['rpe_average']!, _rpeAverageMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('llm_summary_text')) {
      context.handle(
        _llmSummaryTextMeta,
        llmSummaryText.isAcceptableOrUnknown(
          data['llm_summary_text']!,
          _llmSummaryTextMeta,
        ),
      );
    }
    if (data.containsKey('warmup_completed')) {
      context.handle(
        _warmupCompletedMeta,
        warmupCompleted.isAcceptableOrUnknown(
          data['warmup_completed']!,
          _warmupCompletedMeta,
        ),
      );
    }
    if (data.containsKey('stability_completed')) {
      context.handle(
        _stabilityCompletedMeta,
        stabilityCompleted.isAcceptableOrUnknown(
          data['stability_completed']!,
          _stabilityCompletedMeta,
        ),
      );
    }
    if (data.containsKey('cooldown_completed')) {
      context.handle(
        _cooldownCompletedMeta,
        cooldownCompleted.isAcceptableOrUnknown(
          data['cooldown_completed']!,
          _cooldownCompletedMeta,
        ),
      );
    }
    if (data.containsKey('cooldown_type')) {
      context.handle(
        _cooldownTypeMeta,
        cooldownType.isAcceptableOrUnknown(
          data['cooldown_type']!,
          _cooldownTypeMeta,
        ),
      );
    }
    if (data.containsKey('avg_hr')) {
      context.handle(
        _avgHrMeta,
        avgHr.isAcceptableOrUnknown(data['avg_hr']!, _avgHrMeta),
      );
    }
    if (data.containsKey('max_hr')) {
      context.handle(
        _maxHrMeta,
        maxHr.isAcceptableOrUnknown(data['max_hr']!, _maxHrMeta),
      );
    }
    if (data.containsKey('avg_spo2')) {
      context.handle(
        _avgSpo2Meta,
        avgSpo2.isAcceptableOrUnknown(data['avg_spo2']!, _avgSpo2Meta),
      );
    }
    if (data.containsKey('avg_rmssd')) {
      context.handle(
        _avgRmssdMeta,
        avgRmssd.isAcceptableOrUnknown(data['avg_rmssd']!, _avgRmssdMeta),
      );
    }
    if (data.containsKey('bio_stats_json')) {
      context.handle(
        _bioStatsJsonMeta,
        bioStatsJson.isAcceptableOrUnknown(
          data['bio_stats_json']!,
          _bioStatsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}started_at'],
          )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}duration_minutes'],
      ),
      durationScore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration_score'],
      ),
      rpeAverage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe_average'],
      ),
      notes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notes'],
          )!,
      llmSummaryText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}llm_summary_text'],
          )!,
      warmupCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}warmup_completed'],
          )!,
      stabilityCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}stability_completed'],
          )!,
      cooldownCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}cooldown_completed'],
          )!,
      cooldownType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cooldown_type'],
      ),
      avgHr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_hr'],
      ),
      maxHr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_hr'],
      ),
      avgSpo2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_spo2'],
      ),
      avgRmssd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_rmssd'],
      ),
      bioStatsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bio_stats_json'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final int id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String type;
  final double? durationMinutes;
  final String? durationScore;
  final double? rpeAverage;
  final String notes;
  final String llmSummaryText;
  final bool warmupCompleted;
  final bool stabilityCompleted;
  final bool cooldownCompleted;
  final String? cooldownType;
  final double? avgHr;
  final int? maxHr;
  final double? avgSpo2;
  final double? avgRmssd;
  final String? bioStatsJson;
  const WorkoutSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.type,
    this.durationMinutes,
    this.durationScore,
    this.rpeAverage,
    required this.notes,
    required this.llmSummaryText,
    required this.warmupCompleted,
    required this.stabilityCompleted,
    required this.cooldownCompleted,
    this.cooldownType,
    this.avgHr,
    this.maxHr,
    this.avgSpo2,
    this.avgRmssd,
    this.bioStatsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<double>(durationMinutes);
    }
    if (!nullToAbsent || durationScore != null) {
      map['duration_score'] = Variable<String>(durationScore);
    }
    if (!nullToAbsent || rpeAverage != null) {
      map['rpe_average'] = Variable<double>(rpeAverage);
    }
    map['notes'] = Variable<String>(notes);
    map['llm_summary_text'] = Variable<String>(llmSummaryText);
    map['warmup_completed'] = Variable<bool>(warmupCompleted);
    map['stability_completed'] = Variable<bool>(stabilityCompleted);
    map['cooldown_completed'] = Variable<bool>(cooldownCompleted);
    if (!nullToAbsent || cooldownType != null) {
      map['cooldown_type'] = Variable<String>(cooldownType);
    }
    if (!nullToAbsent || avgHr != null) {
      map['avg_hr'] = Variable<double>(avgHr);
    }
    if (!nullToAbsent || maxHr != null) {
      map['max_hr'] = Variable<int>(maxHr);
    }
    if (!nullToAbsent || avgSpo2 != null) {
      map['avg_spo2'] = Variable<double>(avgSpo2);
    }
    if (!nullToAbsent || avgRmssd != null) {
      map['avg_rmssd'] = Variable<double>(avgRmssd);
    }
    if (!nullToAbsent || bioStatsJson != null) {
      map['bio_stats_json'] = Variable<String>(bioStatsJson);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt:
          endedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(endedAt),
      type: Value(type),
      durationMinutes:
          durationMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(durationMinutes),
      durationScore:
          durationScore == null && nullToAbsent
              ? const Value.absent()
              : Value(durationScore),
      rpeAverage:
          rpeAverage == null && nullToAbsent
              ? const Value.absent()
              : Value(rpeAverage),
      notes: Value(notes),
      llmSummaryText: Value(llmSummaryText),
      warmupCompleted: Value(warmupCompleted),
      stabilityCompleted: Value(stabilityCompleted),
      cooldownCompleted: Value(cooldownCompleted),
      cooldownType:
          cooldownType == null && nullToAbsent
              ? const Value.absent()
              : Value(cooldownType),
      avgHr:
          avgHr == null && nullToAbsent ? const Value.absent() : Value(avgHr),
      maxHr:
          maxHr == null && nullToAbsent ? const Value.absent() : Value(maxHr),
      avgSpo2:
          avgSpo2 == null && nullToAbsent
              ? const Value.absent()
              : Value(avgSpo2),
      avgRmssd:
          avgRmssd == null && nullToAbsent
              ? const Value.absent()
              : Value(avgRmssd),
      bioStatsJson:
          bioStatsJson == null && nullToAbsent
              ? const Value.absent()
              : Value(bioStatsJson),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      type: serializer.fromJson<String>(json['type']),
      durationMinutes: serializer.fromJson<double?>(json['durationMinutes']),
      durationScore: serializer.fromJson<String?>(json['durationScore']),
      rpeAverage: serializer.fromJson<double?>(json['rpeAverage']),
      notes: serializer.fromJson<String>(json['notes']),
      llmSummaryText: serializer.fromJson<String>(json['llmSummaryText']),
      warmupCompleted: serializer.fromJson<bool>(json['warmupCompleted']),
      stabilityCompleted: serializer.fromJson<bool>(json['stabilityCompleted']),
      cooldownCompleted: serializer.fromJson<bool>(json['cooldownCompleted']),
      cooldownType: serializer.fromJson<String?>(json['cooldownType']),
      avgHr: serializer.fromJson<double?>(json['avgHr']),
      maxHr: serializer.fromJson<int?>(json['maxHr']),
      avgSpo2: serializer.fromJson<double?>(json['avgSpo2']),
      avgRmssd: serializer.fromJson<double?>(json['avgRmssd']),
      bioStatsJson: serializer.fromJson<String?>(json['bioStatsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'type': serializer.toJson<String>(type),
      'durationMinutes': serializer.toJson<double?>(durationMinutes),
      'durationScore': serializer.toJson<String?>(durationScore),
      'rpeAverage': serializer.toJson<double?>(rpeAverage),
      'notes': serializer.toJson<String>(notes),
      'llmSummaryText': serializer.toJson<String>(llmSummaryText),
      'warmupCompleted': serializer.toJson<bool>(warmupCompleted),
      'stabilityCompleted': serializer.toJson<bool>(stabilityCompleted),
      'cooldownCompleted': serializer.toJson<bool>(cooldownCompleted),
      'cooldownType': serializer.toJson<String?>(cooldownType),
      'avgHr': serializer.toJson<double?>(avgHr),
      'maxHr': serializer.toJson<int?>(maxHr),
      'avgSpo2': serializer.toJson<double?>(avgSpo2),
      'avgRmssd': serializer.toJson<double?>(avgRmssd),
      'bioStatsJson': serializer.toJson<String?>(bioStatsJson),
    };
  }

  WorkoutSession copyWith({
    int? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    String? type,
    Value<double?> durationMinutes = const Value.absent(),
    Value<String?> durationScore = const Value.absent(),
    Value<double?> rpeAverage = const Value.absent(),
    String? notes,
    String? llmSummaryText,
    bool? warmupCompleted,
    bool? stabilityCompleted,
    bool? cooldownCompleted,
    Value<String?> cooldownType = const Value.absent(),
    Value<double?> avgHr = const Value.absent(),
    Value<int?> maxHr = const Value.absent(),
    Value<double?> avgSpo2 = const Value.absent(),
    Value<double?> avgRmssd = const Value.absent(),
    Value<String?> bioStatsJson = const Value.absent(),
  }) => WorkoutSession(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    type: type ?? this.type,
    durationMinutes:
        durationMinutes.present ? durationMinutes.value : this.durationMinutes,
    durationScore:
        durationScore.present ? durationScore.value : this.durationScore,
    rpeAverage: rpeAverage.present ? rpeAverage.value : this.rpeAverage,
    notes: notes ?? this.notes,
    llmSummaryText: llmSummaryText ?? this.llmSummaryText,
    warmupCompleted: warmupCompleted ?? this.warmupCompleted,
    stabilityCompleted: stabilityCompleted ?? this.stabilityCompleted,
    cooldownCompleted: cooldownCompleted ?? this.cooldownCompleted,
    cooldownType: cooldownType.present ? cooldownType.value : this.cooldownType,
    avgHr: avgHr.present ? avgHr.value : this.avgHr,
    maxHr: maxHr.present ? maxHr.value : this.maxHr,
    avgSpo2: avgSpo2.present ? avgSpo2.value : this.avgSpo2,
    avgRmssd: avgRmssd.present ? avgRmssd.value : this.avgRmssd,
    bioStatsJson: bioStatsJson.present ? bioStatsJson.value : this.bioStatsJson,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      type: data.type.present ? data.type.value : this.type,
      durationMinutes:
          data.durationMinutes.present
              ? data.durationMinutes.value
              : this.durationMinutes,
      durationScore:
          data.durationScore.present
              ? data.durationScore.value
              : this.durationScore,
      rpeAverage:
          data.rpeAverage.present ? data.rpeAverage.value : this.rpeAverage,
      notes: data.notes.present ? data.notes.value : this.notes,
      llmSummaryText:
          data.llmSummaryText.present
              ? data.llmSummaryText.value
              : this.llmSummaryText,
      warmupCompleted:
          data.warmupCompleted.present
              ? data.warmupCompleted.value
              : this.warmupCompleted,
      stabilityCompleted:
          data.stabilityCompleted.present
              ? data.stabilityCompleted.value
              : this.stabilityCompleted,
      cooldownCompleted:
          data.cooldownCompleted.present
              ? data.cooldownCompleted.value
              : this.cooldownCompleted,
      cooldownType:
          data.cooldownType.present
              ? data.cooldownType.value
              : this.cooldownType,
      avgHr: data.avgHr.present ? data.avgHr.value : this.avgHr,
      maxHr: data.maxHr.present ? data.maxHr.value : this.maxHr,
      avgSpo2: data.avgSpo2.present ? data.avgSpo2.value : this.avgSpo2,
      avgRmssd: data.avgRmssd.present ? data.avgRmssd.value : this.avgRmssd,
      bioStatsJson:
          data.bioStatsJson.present
              ? data.bioStatsJson.value
              : this.bioStatsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('type: $type, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('durationScore: $durationScore, ')
          ..write('rpeAverage: $rpeAverage, ')
          ..write('notes: $notes, ')
          ..write('llmSummaryText: $llmSummaryText, ')
          ..write('warmupCompleted: $warmupCompleted, ')
          ..write('stabilityCompleted: $stabilityCompleted, ')
          ..write('cooldownCompleted: $cooldownCompleted, ')
          ..write('cooldownType: $cooldownType, ')
          ..write('avgHr: $avgHr, ')
          ..write('maxHr: $maxHr, ')
          ..write('avgSpo2: $avgSpo2, ')
          ..write('avgRmssd: $avgRmssd, ')
          ..write('bioStatsJson: $bioStatsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    endedAt,
    type,
    durationMinutes,
    durationScore,
    rpeAverage,
    notes,
    llmSummaryText,
    warmupCompleted,
    stabilityCompleted,
    cooldownCompleted,
    cooldownType,
    avgHr,
    maxHr,
    avgSpo2,
    avgRmssd,
    bioStatsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.type == this.type &&
          other.durationMinutes == this.durationMinutes &&
          other.durationScore == this.durationScore &&
          other.rpeAverage == this.rpeAverage &&
          other.notes == this.notes &&
          other.llmSummaryText == this.llmSummaryText &&
          other.warmupCompleted == this.warmupCompleted &&
          other.stabilityCompleted == this.stabilityCompleted &&
          other.cooldownCompleted == this.cooldownCompleted &&
          other.cooldownType == this.cooldownType &&
          other.avgHr == this.avgHr &&
          other.maxHr == this.maxHr &&
          other.avgSpo2 == this.avgSpo2 &&
          other.avgRmssd == this.avgRmssd &&
          other.bioStatsJson == this.bioStatsJson);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> type;
  final Value<double?> durationMinutes;
  final Value<String?> durationScore;
  final Value<double?> rpeAverage;
  final Value<String> notes;
  final Value<String> llmSummaryText;
  final Value<bool> warmupCompleted;
  final Value<bool> stabilityCompleted;
  final Value<bool> cooldownCompleted;
  final Value<String?> cooldownType;
  final Value<double?> avgHr;
  final Value<int?> maxHr;
  final Value<double?> avgSpo2;
  final Value<double?> avgRmssd;
  final Value<String?> bioStatsJson;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.type = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.durationScore = const Value.absent(),
    this.rpeAverage = const Value.absent(),
    this.notes = const Value.absent(),
    this.llmSummaryText = const Value.absent(),
    this.warmupCompleted = const Value.absent(),
    this.stabilityCompleted = const Value.absent(),
    this.cooldownCompleted = const Value.absent(),
    this.cooldownType = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.maxHr = const Value.absent(),
    this.avgSpo2 = const Value.absent(),
    this.avgRmssd = const Value.absent(),
    this.bioStatsJson = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required String type,
    this.durationMinutes = const Value.absent(),
    this.durationScore = const Value.absent(),
    this.rpeAverage = const Value.absent(),
    this.notes = const Value.absent(),
    this.llmSummaryText = const Value.absent(),
    this.warmupCompleted = const Value.absent(),
    this.stabilityCompleted = const Value.absent(),
    this.cooldownCompleted = const Value.absent(),
    this.cooldownType = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.maxHr = const Value.absent(),
    this.avgSpo2 = const Value.absent(),
    this.avgRmssd = const Value.absent(),
    this.bioStatsJson = const Value.absent(),
  }) : startedAt = Value(startedAt),
       type = Value(type);
  static Insertable<WorkoutSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? type,
    Expression<double>? durationMinutes,
    Expression<String>? durationScore,
    Expression<double>? rpeAverage,
    Expression<String>? notes,
    Expression<String>? llmSummaryText,
    Expression<bool>? warmupCompleted,
    Expression<bool>? stabilityCompleted,
    Expression<bool>? cooldownCompleted,
    Expression<String>? cooldownType,
    Expression<double>? avgHr,
    Expression<int>? maxHr,
    Expression<double>? avgSpo2,
    Expression<double>? avgRmssd,
    Expression<String>? bioStatsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (type != null) 'type': type,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (durationScore != null) 'duration_score': durationScore,
      if (rpeAverage != null) 'rpe_average': rpeAverage,
      if (notes != null) 'notes': notes,
      if (llmSummaryText != null) 'llm_summary_text': llmSummaryText,
      if (warmupCompleted != null) 'warmup_completed': warmupCompleted,
      if (stabilityCompleted != null) 'stability_completed': stabilityCompleted,
      if (cooldownCompleted != null) 'cooldown_completed': cooldownCompleted,
      if (cooldownType != null) 'cooldown_type': cooldownType,
      if (avgHr != null) 'avg_hr': avgHr,
      if (maxHr != null) 'max_hr': maxHr,
      if (avgSpo2 != null) 'avg_spo2': avgSpo2,
      if (avgRmssd != null) 'avg_rmssd': avgRmssd,
      if (bioStatsJson != null) 'bio_stats_json': bioStatsJson,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? type,
    Value<double?>? durationMinutes,
    Value<String?>? durationScore,
    Value<double?>? rpeAverage,
    Value<String>? notes,
    Value<String>? llmSummaryText,
    Value<bool>? warmupCompleted,
    Value<bool>? stabilityCompleted,
    Value<bool>? cooldownCompleted,
    Value<String?>? cooldownType,
    Value<double?>? avgHr,
    Value<int?>? maxHr,
    Value<double?>? avgSpo2,
    Value<double?>? avgRmssd,
    Value<String?>? bioStatsJson,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      durationScore: durationScore ?? this.durationScore,
      rpeAverage: rpeAverage ?? this.rpeAverage,
      notes: notes ?? this.notes,
      llmSummaryText: llmSummaryText ?? this.llmSummaryText,
      warmupCompleted: warmupCompleted ?? this.warmupCompleted,
      stabilityCompleted: stabilityCompleted ?? this.stabilityCompleted,
      cooldownCompleted: cooldownCompleted ?? this.cooldownCompleted,
      cooldownType: cooldownType ?? this.cooldownType,
      avgHr: avgHr ?? this.avgHr,
      maxHr: maxHr ?? this.maxHr,
      avgSpo2: avgSpo2 ?? this.avgSpo2,
      avgRmssd: avgRmssd ?? this.avgRmssd,
      bioStatsJson: bioStatsJson ?? this.bioStatsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<double>(durationMinutes.value);
    }
    if (durationScore.present) {
      map['duration_score'] = Variable<String>(durationScore.value);
    }
    if (rpeAverage.present) {
      map['rpe_average'] = Variable<double>(rpeAverage.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (llmSummaryText.present) {
      map['llm_summary_text'] = Variable<String>(llmSummaryText.value);
    }
    if (warmupCompleted.present) {
      map['warmup_completed'] = Variable<bool>(warmupCompleted.value);
    }
    if (stabilityCompleted.present) {
      map['stability_completed'] = Variable<bool>(stabilityCompleted.value);
    }
    if (cooldownCompleted.present) {
      map['cooldown_completed'] = Variable<bool>(cooldownCompleted.value);
    }
    if (cooldownType.present) {
      map['cooldown_type'] = Variable<String>(cooldownType.value);
    }
    if (avgHr.present) {
      map['avg_hr'] = Variable<double>(avgHr.value);
    }
    if (maxHr.present) {
      map['max_hr'] = Variable<int>(maxHr.value);
    }
    if (avgSpo2.present) {
      map['avg_spo2'] = Variable<double>(avgSpo2.value);
    }
    if (avgRmssd.present) {
      map['avg_rmssd'] = Variable<double>(avgRmssd.value);
    }
    if (bioStatsJson.present) {
      map['bio_stats_json'] = Variable<String>(bioStatsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('type: $type, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('durationScore: $durationScore, ')
          ..write('rpeAverage: $rpeAverage, ')
          ..write('notes: $notes, ')
          ..write('llmSummaryText: $llmSummaryText, ')
          ..write('warmupCompleted: $warmupCompleted, ')
          ..write('stabilityCompleted: $stabilityCompleted, ')
          ..write('cooldownCompleted: $cooldownCompleted, ')
          ..write('cooldownType: $cooldownType, ')
          ..write('avgHr: $avgHr, ')
          ..write('maxHr: $maxHr, ')
          ..write('avgSpo2: $avgSpo2, ')
          ..write('avgRmssd: $avgRmssd, ')
          ..write('bioStatsJson: $bioStatsJson')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsTargetMeta = const VerificationMeta(
    'repsTarget',
  );
  @override
  late final GeneratedColumn<int> repsTarget = GeneratedColumn<int>(
    'reps_target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repsCompletedMeta = const VerificationMeta(
    'repsCompleted',
  );
  @override
  late final GeneratedColumn<int> repsCompleted = GeneratedColumn<int>(
    'reps_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempoEccentricMeta = const VerificationMeta(
    'tempoEccentric',
  );
  @override
  late final GeneratedColumn<int> tempoEccentric = GeneratedColumn<int>(
    'tempo_eccentric',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _tempoConcentricMeta = const VerificationMeta(
    'tempoConcentric',
  );
  @override
  late final GeneratedColumn<int> tempoConcentric = GeneratedColumn<int>(
    'tempo_concentric',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _restSecondsAfterMeta = const VerificationMeta(
    'restSecondsAfter',
  );
  @override
  late final GeneratedColumn<int> restSecondsAfter = GeneratedColumn<int>(
    'rest_seconds_after',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(120),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _avgHrMeta = const VerificationMeta('avgHr');
  @override
  late final GeneratedColumn<double> avgHr = GeneratedColumn<double>(
    'avg_hr',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxHrMeta = const VerificationMeta('maxHr');
  @override
  late final GeneratedColumn<int> maxHr = GeneratedColumn<int>(
    'max_hr',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spo2Meta = const VerificationMeta('spo2');
  @override
  late final GeneratedColumn<int> spo2 = GeneratedColumn<int>(
    'spo2',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rmssdMeta = const VerificationMeta('rmssd');
  @override
  late final GeneratedColumn<double> rmssd = GeneratedColumn<double>(
    'rmssd',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressIndexMeta = const VerificationMeta(
    'stressIndex',
  );
  @override
  late final GeneratedColumn<double> stressIndex = GeneratedColumn<double>(
    'stress_index',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrRecoveryBpmMeta = const VerificationMeta(
    'hrRecoveryBpm',
  );
  @override
  late final GeneratedColumn<int> hrRecoveryBpm = GeneratedColumn<int>(
    'hr_recovery_bpm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skinTempMeta = const VerificationMeta(
    'skinTemp',
  );
  @override
  late final GeneratedColumn<double> skinTemp = GeneratedColumn<double>(
    'skin_temp',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    setNumber,
    repsTarget,
    repsCompleted,
    rpe,
    tempoEccentric,
    tempoConcentric,
    restSecondsAfter,
    notes,
    avgHr,
    maxHr,
    spo2,
    rmssd,
    stressIndex,
    hrRecoveryBpm,
    skinTemp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('reps_target')) {
      context.handle(
        _repsTargetMeta,
        repsTarget.isAcceptableOrUnknown(data['reps_target']!, _repsTargetMeta),
      );
    }
    if (data.containsKey('reps_completed')) {
      context.handle(
        _repsCompletedMeta,
        repsCompleted.isAcceptableOrUnknown(
          data['reps_completed']!,
          _repsCompletedMeta,
        ),
      );
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('tempo_eccentric')) {
      context.handle(
        _tempoEccentricMeta,
        tempoEccentric.isAcceptableOrUnknown(
          data['tempo_eccentric']!,
          _tempoEccentricMeta,
        ),
      );
    }
    if (data.containsKey('tempo_concentric')) {
      context.handle(
        _tempoConcentricMeta,
        tempoConcentric.isAcceptableOrUnknown(
          data['tempo_concentric']!,
          _tempoConcentricMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds_after')) {
      context.handle(
        _restSecondsAfterMeta,
        restSecondsAfter.isAcceptableOrUnknown(
          data['rest_seconds_after']!,
          _restSecondsAfterMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('avg_hr')) {
      context.handle(
        _avgHrMeta,
        avgHr.isAcceptableOrUnknown(data['avg_hr']!, _avgHrMeta),
      );
    }
    if (data.containsKey('max_hr')) {
      context.handle(
        _maxHrMeta,
        maxHr.isAcceptableOrUnknown(data['max_hr']!, _maxHrMeta),
      );
    }
    if (data.containsKey('spo2')) {
      context.handle(
        _spo2Meta,
        spo2.isAcceptableOrUnknown(data['spo2']!, _spo2Meta),
      );
    }
    if (data.containsKey('rmssd')) {
      context.handle(
        _rmssdMeta,
        rmssd.isAcceptableOrUnknown(data['rmssd']!, _rmssdMeta),
      );
    }
    if (data.containsKey('stress_index')) {
      context.handle(
        _stressIndexMeta,
        stressIndex.isAcceptableOrUnknown(
          data['stress_index']!,
          _stressIndexMeta,
        ),
      );
    }
    if (data.containsKey('hr_recovery_bpm')) {
      context.handle(
        _hrRecoveryBpmMeta,
        hrRecoveryBpm.isAcceptableOrUnknown(
          data['hr_recovery_bpm']!,
          _hrRecoveryBpmMeta,
        ),
      );
    }
    if (data.containsKey('skin_temp')) {
      context.handle(
        _skinTempMeta,
        skinTemp.isAcceptableOrUnknown(data['skin_temp']!, _skinTempMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sessionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}session_id'],
          )!,
      exerciseId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}exercise_id'],
          )!,
      setNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}set_number'],
          )!,
      repsTarget:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}reps_target'],
          )!,
      repsCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}reps_completed'],
          )!,
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      ),
      tempoEccentric:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}tempo_eccentric'],
          )!,
      tempoConcentric:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}tempo_concentric'],
          )!,
      restSecondsAfter:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}rest_seconds_after'],
          )!,
      notes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notes'],
          )!,
      avgHr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_hr'],
      ),
      maxHr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_hr'],
      ),
      spo2: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spo2'],
      ),
      rmssd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rmssd'],
      ),
      stressIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stress_index'],
      ),
      hrRecoveryBpm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hr_recovery_bpm'],
      ),
      skinTemp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}skin_temp'],
      ),
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final int id;
  final int sessionId;
  final int exerciseId;
  final int setNumber;
  final int repsTarget;
  final int repsCompleted;
  final double? rpe;
  final int tempoEccentric;
  final int tempoConcentric;
  final int restSecondsAfter;
  final String notes;
  final double? avgHr;
  final int? maxHr;
  final int? spo2;
  final double? rmssd;
  final double? stressIndex;
  final int? hrRecoveryBpm;
  final double? skinTemp;
  const WorkoutSet({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.setNumber,
    required this.repsTarget,
    required this.repsCompleted,
    this.rpe,
    required this.tempoEccentric,
    required this.tempoConcentric,
    required this.restSecondsAfter,
    required this.notes,
    this.avgHr,
    this.maxHr,
    this.spo2,
    this.rmssd,
    this.stressIndex,
    this.hrRecoveryBpm,
    this.skinTemp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['set_number'] = Variable<int>(setNumber);
    map['reps_target'] = Variable<int>(repsTarget);
    map['reps_completed'] = Variable<int>(repsCompleted);
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    map['tempo_eccentric'] = Variable<int>(tempoEccentric);
    map['tempo_concentric'] = Variable<int>(tempoConcentric);
    map['rest_seconds_after'] = Variable<int>(restSecondsAfter);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || avgHr != null) {
      map['avg_hr'] = Variable<double>(avgHr);
    }
    if (!nullToAbsent || maxHr != null) {
      map['max_hr'] = Variable<int>(maxHr);
    }
    if (!nullToAbsent || spo2 != null) {
      map['spo2'] = Variable<int>(spo2);
    }
    if (!nullToAbsent || rmssd != null) {
      map['rmssd'] = Variable<double>(rmssd);
    }
    if (!nullToAbsent || stressIndex != null) {
      map['stress_index'] = Variable<double>(stressIndex);
    }
    if (!nullToAbsent || hrRecoveryBpm != null) {
      map['hr_recovery_bpm'] = Variable<int>(hrRecoveryBpm);
    }
    if (!nullToAbsent || skinTemp != null) {
      map['skin_temp'] = Variable<double>(skinTemp);
    }
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      setNumber: Value(setNumber),
      repsTarget: Value(repsTarget),
      repsCompleted: Value(repsCompleted),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      tempoEccentric: Value(tempoEccentric),
      tempoConcentric: Value(tempoConcentric),
      restSecondsAfter: Value(restSecondsAfter),
      notes: Value(notes),
      avgHr:
          avgHr == null && nullToAbsent ? const Value.absent() : Value(avgHr),
      maxHr:
          maxHr == null && nullToAbsent ? const Value.absent() : Value(maxHr),
      spo2: spo2 == null && nullToAbsent ? const Value.absent() : Value(spo2),
      rmssd:
          rmssd == null && nullToAbsent ? const Value.absent() : Value(rmssd),
      stressIndex:
          stressIndex == null && nullToAbsent
              ? const Value.absent()
              : Value(stressIndex),
      hrRecoveryBpm:
          hrRecoveryBpm == null && nullToAbsent
              ? const Value.absent()
              : Value(hrRecoveryBpm),
      skinTemp:
          skinTemp == null && nullToAbsent
              ? const Value.absent()
              : Value(skinTemp),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      repsTarget: serializer.fromJson<int>(json['repsTarget']),
      repsCompleted: serializer.fromJson<int>(json['repsCompleted']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      tempoEccentric: serializer.fromJson<int>(json['tempoEccentric']),
      tempoConcentric: serializer.fromJson<int>(json['tempoConcentric']),
      restSecondsAfter: serializer.fromJson<int>(json['restSecondsAfter']),
      notes: serializer.fromJson<String>(json['notes']),
      avgHr: serializer.fromJson<double?>(json['avgHr']),
      maxHr: serializer.fromJson<int?>(json['maxHr']),
      spo2: serializer.fromJson<int?>(json['spo2']),
      rmssd: serializer.fromJson<double?>(json['rmssd']),
      stressIndex: serializer.fromJson<double?>(json['stressIndex']),
      hrRecoveryBpm: serializer.fromJson<int?>(json['hrRecoveryBpm']),
      skinTemp: serializer.fromJson<double?>(json['skinTemp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'repsTarget': serializer.toJson<int>(repsTarget),
      'repsCompleted': serializer.toJson<int>(repsCompleted),
      'rpe': serializer.toJson<double?>(rpe),
      'tempoEccentric': serializer.toJson<int>(tempoEccentric),
      'tempoConcentric': serializer.toJson<int>(tempoConcentric),
      'restSecondsAfter': serializer.toJson<int>(restSecondsAfter),
      'notes': serializer.toJson<String>(notes),
      'avgHr': serializer.toJson<double?>(avgHr),
      'maxHr': serializer.toJson<int?>(maxHr),
      'spo2': serializer.toJson<int?>(spo2),
      'rmssd': serializer.toJson<double?>(rmssd),
      'stressIndex': serializer.toJson<double?>(stressIndex),
      'hrRecoveryBpm': serializer.toJson<int?>(hrRecoveryBpm),
      'skinTemp': serializer.toJson<double?>(skinTemp),
    };
  }

  WorkoutSet copyWith({
    int? id,
    int? sessionId,
    int? exerciseId,
    int? setNumber,
    int? repsTarget,
    int? repsCompleted,
    Value<double?> rpe = const Value.absent(),
    int? tempoEccentric,
    int? tempoConcentric,
    int? restSecondsAfter,
    String? notes,
    Value<double?> avgHr = const Value.absent(),
    Value<int?> maxHr = const Value.absent(),
    Value<int?> spo2 = const Value.absent(),
    Value<double?> rmssd = const Value.absent(),
    Value<double?> stressIndex = const Value.absent(),
    Value<int?> hrRecoveryBpm = const Value.absent(),
    Value<double?> skinTemp = const Value.absent(),
  }) => WorkoutSet(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    setNumber: setNumber ?? this.setNumber,
    repsTarget: repsTarget ?? this.repsTarget,
    repsCompleted: repsCompleted ?? this.repsCompleted,
    rpe: rpe.present ? rpe.value : this.rpe,
    tempoEccentric: tempoEccentric ?? this.tempoEccentric,
    tempoConcentric: tempoConcentric ?? this.tempoConcentric,
    restSecondsAfter: restSecondsAfter ?? this.restSecondsAfter,
    notes: notes ?? this.notes,
    avgHr: avgHr.present ? avgHr.value : this.avgHr,
    maxHr: maxHr.present ? maxHr.value : this.maxHr,
    spo2: spo2.present ? spo2.value : this.spo2,
    rmssd: rmssd.present ? rmssd.value : this.rmssd,
    stressIndex: stressIndex.present ? stressIndex.value : this.stressIndex,
    hrRecoveryBpm:
        hrRecoveryBpm.present ? hrRecoveryBpm.value : this.hrRecoveryBpm,
    skinTemp: skinTemp.present ? skinTemp.value : this.skinTemp,
  );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      repsTarget:
          data.repsTarget.present ? data.repsTarget.value : this.repsTarget,
      repsCompleted:
          data.repsCompleted.present
              ? data.repsCompleted.value
              : this.repsCompleted,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      tempoEccentric:
          data.tempoEccentric.present
              ? data.tempoEccentric.value
              : this.tempoEccentric,
      tempoConcentric:
          data.tempoConcentric.present
              ? data.tempoConcentric.value
              : this.tempoConcentric,
      restSecondsAfter:
          data.restSecondsAfter.present
              ? data.restSecondsAfter.value
              : this.restSecondsAfter,
      notes: data.notes.present ? data.notes.value : this.notes,
      avgHr: data.avgHr.present ? data.avgHr.value : this.avgHr,
      maxHr: data.maxHr.present ? data.maxHr.value : this.maxHr,
      spo2: data.spo2.present ? data.spo2.value : this.spo2,
      rmssd: data.rmssd.present ? data.rmssd.value : this.rmssd,
      stressIndex:
          data.stressIndex.present ? data.stressIndex.value : this.stressIndex,
      hrRecoveryBpm:
          data.hrRecoveryBpm.present
              ? data.hrRecoveryBpm.value
              : this.hrRecoveryBpm,
      skinTemp: data.skinTemp.present ? data.skinTemp.value : this.skinTemp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('repsTarget: $repsTarget, ')
          ..write('repsCompleted: $repsCompleted, ')
          ..write('rpe: $rpe, ')
          ..write('tempoEccentric: $tempoEccentric, ')
          ..write('tempoConcentric: $tempoConcentric, ')
          ..write('restSecondsAfter: $restSecondsAfter, ')
          ..write('notes: $notes, ')
          ..write('avgHr: $avgHr, ')
          ..write('maxHr: $maxHr, ')
          ..write('spo2: $spo2, ')
          ..write('rmssd: $rmssd, ')
          ..write('stressIndex: $stressIndex, ')
          ..write('hrRecoveryBpm: $hrRecoveryBpm, ')
          ..write('skinTemp: $skinTemp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseId,
    setNumber,
    repsTarget,
    repsCompleted,
    rpe,
    tempoEccentric,
    tempoConcentric,
    restSecondsAfter,
    notes,
    avgHr,
    maxHr,
    spo2,
    rmssd,
    stressIndex,
    hrRecoveryBpm,
    skinTemp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.setNumber == this.setNumber &&
          other.repsTarget == this.repsTarget &&
          other.repsCompleted == this.repsCompleted &&
          other.rpe == this.rpe &&
          other.tempoEccentric == this.tempoEccentric &&
          other.tempoConcentric == this.tempoConcentric &&
          other.restSecondsAfter == this.restSecondsAfter &&
          other.notes == this.notes &&
          other.avgHr == this.avgHr &&
          other.maxHr == this.maxHr &&
          other.spo2 == this.spo2 &&
          other.rmssd == this.rmssd &&
          other.stressIndex == this.stressIndex &&
          other.hrRecoveryBpm == this.hrRecoveryBpm &&
          other.skinTemp == this.skinTemp);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> exerciseId;
  final Value<int> setNumber;
  final Value<int> repsTarget;
  final Value<int> repsCompleted;
  final Value<double?> rpe;
  final Value<int> tempoEccentric;
  final Value<int> tempoConcentric;
  final Value<int> restSecondsAfter;
  final Value<String> notes;
  final Value<double?> avgHr;
  final Value<int?> maxHr;
  final Value<int?> spo2;
  final Value<double?> rmssd;
  final Value<double?> stressIndex;
  final Value<int?> hrRecoveryBpm;
  final Value<double?> skinTemp;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.repsTarget = const Value.absent(),
    this.repsCompleted = const Value.absent(),
    this.rpe = const Value.absent(),
    this.tempoEccentric = const Value.absent(),
    this.tempoConcentric = const Value.absent(),
    this.restSecondsAfter = const Value.absent(),
    this.notes = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.maxHr = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.rmssd = const Value.absent(),
    this.stressIndex = const Value.absent(),
    this.hrRecoveryBpm = const Value.absent(),
    this.skinTemp = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int exerciseId,
    required int setNumber,
    this.repsTarget = const Value.absent(),
    this.repsCompleted = const Value.absent(),
    this.rpe = const Value.absent(),
    this.tempoEccentric = const Value.absent(),
    this.tempoConcentric = const Value.absent(),
    this.restSecondsAfter = const Value.absent(),
    this.notes = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.maxHr = const Value.absent(),
    this.spo2 = const Value.absent(),
    this.rmssd = const Value.absent(),
    this.stressIndex = const Value.absent(),
    this.hrRecoveryBpm = const Value.absent(),
    this.skinTemp = const Value.absent(),
  }) : sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       setNumber = Value(setNumber);
  static Insertable<WorkoutSet> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? exerciseId,
    Expression<int>? setNumber,
    Expression<int>? repsTarget,
    Expression<int>? repsCompleted,
    Expression<double>? rpe,
    Expression<int>? tempoEccentric,
    Expression<int>? tempoConcentric,
    Expression<int>? restSecondsAfter,
    Expression<String>? notes,
    Expression<double>? avgHr,
    Expression<int>? maxHr,
    Expression<int>? spo2,
    Expression<double>? rmssd,
    Expression<double>? stressIndex,
    Expression<int>? hrRecoveryBpm,
    Expression<double>? skinTemp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (repsTarget != null) 'reps_target': repsTarget,
      if (repsCompleted != null) 'reps_completed': repsCompleted,
      if (rpe != null) 'rpe': rpe,
      if (tempoEccentric != null) 'tempo_eccentric': tempoEccentric,
      if (tempoConcentric != null) 'tempo_concentric': tempoConcentric,
      if (restSecondsAfter != null) 'rest_seconds_after': restSecondsAfter,
      if (notes != null) 'notes': notes,
      if (avgHr != null) 'avg_hr': avgHr,
      if (maxHr != null) 'max_hr': maxHr,
      if (spo2 != null) 'spo2': spo2,
      if (rmssd != null) 'rmssd': rmssd,
      if (stressIndex != null) 'stress_index': stressIndex,
      if (hrRecoveryBpm != null) 'hr_recovery_bpm': hrRecoveryBpm,
      if (skinTemp != null) 'skin_temp': skinTemp,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? exerciseId,
    Value<int>? setNumber,
    Value<int>? repsTarget,
    Value<int>? repsCompleted,
    Value<double?>? rpe,
    Value<int>? tempoEccentric,
    Value<int>? tempoConcentric,
    Value<int>? restSecondsAfter,
    Value<String>? notes,
    Value<double?>? avgHr,
    Value<int?>? maxHr,
    Value<int?>? spo2,
    Value<double?>? rmssd,
    Value<double?>? stressIndex,
    Value<int?>? hrRecoveryBpm,
    Value<double?>? skinTemp,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      repsTarget: repsTarget ?? this.repsTarget,
      repsCompleted: repsCompleted ?? this.repsCompleted,
      rpe: rpe ?? this.rpe,
      tempoEccentric: tempoEccentric ?? this.tempoEccentric,
      tempoConcentric: tempoConcentric ?? this.tempoConcentric,
      restSecondsAfter: restSecondsAfter ?? this.restSecondsAfter,
      notes: notes ?? this.notes,
      avgHr: avgHr ?? this.avgHr,
      maxHr: maxHr ?? this.maxHr,
      spo2: spo2 ?? this.spo2,
      rmssd: rmssd ?? this.rmssd,
      stressIndex: stressIndex ?? this.stressIndex,
      hrRecoveryBpm: hrRecoveryBpm ?? this.hrRecoveryBpm,
      skinTemp: skinTemp ?? this.skinTemp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (repsTarget.present) {
      map['reps_target'] = Variable<int>(repsTarget.value);
    }
    if (repsCompleted.present) {
      map['reps_completed'] = Variable<int>(repsCompleted.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (tempoEccentric.present) {
      map['tempo_eccentric'] = Variable<int>(tempoEccentric.value);
    }
    if (tempoConcentric.present) {
      map['tempo_concentric'] = Variable<int>(tempoConcentric.value);
    }
    if (restSecondsAfter.present) {
      map['rest_seconds_after'] = Variable<int>(restSecondsAfter.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (avgHr.present) {
      map['avg_hr'] = Variable<double>(avgHr.value);
    }
    if (maxHr.present) {
      map['max_hr'] = Variable<int>(maxHr.value);
    }
    if (spo2.present) {
      map['spo2'] = Variable<int>(spo2.value);
    }
    if (rmssd.present) {
      map['rmssd'] = Variable<double>(rmssd.value);
    }
    if (stressIndex.present) {
      map['stress_index'] = Variable<double>(stressIndex.value);
    }
    if (hrRecoveryBpm.present) {
      map['hr_recovery_bpm'] = Variable<int>(hrRecoveryBpm.value);
    }
    if (skinTemp.present) {
      map['skin_temp'] = Variable<double>(skinTemp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('repsTarget: $repsTarget, ')
          ..write('repsCompleted: $repsCompleted, ')
          ..write('rpe: $rpe, ')
          ..write('tempoEccentric: $tempoEccentric, ')
          ..write('tempoConcentric: $tempoConcentric, ')
          ..write('restSecondsAfter: $restSecondsAfter, ')
          ..write('notes: $notes, ')
          ..write('avgHr: $avgHr, ')
          ..write('maxHr: $maxHr, ')
          ..write('spo2: $spo2, ')
          ..write('rmssd: $rmssd, ')
          ..write('stressIndex: $stressIndex, ')
          ..write('hrRecoveryBpm: $hrRecoveryBpm, ')
          ..write('skinTemp: $skinTemp')
          ..write(')'))
        .toString();
  }
}

class $FastingSessionsTable extends FastingSessions
    with TableInfo<$FastingSessionsTable, FastingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FastingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetHoursMeta = const VerificationMeta(
    'targetHours',
  );
  @override
  late final GeneratedColumn<double> targetHours = GeneratedColumn<double>(
    'target_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualHoursMeta = const VerificationMeta(
    'actualHours',
  );
  @override
  late final GeneratedColumn<double> actualHours = GeneratedColumn<double>(
    'actual_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _glucoseReadingsJsonMeta =
      const VerificationMeta('glucoseReadingsJson');
  @override
  late final GeneratedColumn<String> glucoseReadingsJson =
      GeneratedColumn<String>(
        'glucose_readings_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _hrvReadingsJsonMeta = const VerificationMeta(
    'hrvReadingsJson',
  );
  @override
  late final GeneratedColumn<String> hrvReadingsJson = GeneratedColumn<String>(
    'hrv_readings_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _refeedingNotesMeta = const VerificationMeta(
    'refeedingNotes',
  );
  @override
  late final GeneratedColumn<String> refeedingNotes = GeneratedColumn<String>(
    'refeeding_notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _toleranceScoreMeta = const VerificationMeta(
    'toleranceScore',
  );
  @override
  late final GeneratedColumn<double> toleranceScore = GeneratedColumn<double>(
    'tolerance_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyScoreMeta = const VerificationMeta(
    'energyScore',
  );
  @override
  late final GeneratedColumn<int> energyScore = GeneratedColumn<int>(
    'energy_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterCountMeta = const VerificationMeta(
    'waterCount',
  );
  @override
  late final GeneratedColumn<int> waterCount = GeneratedColumn<int>(
    'water_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _llmSummaryTextMeta = const VerificationMeta(
    'llmSummaryText',
  );
  @override
  late final GeneratedColumn<String> llmSummaryText = GeneratedColumn<String>(
    'llm_summary_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    endedAt,
    targetHours,
    actualHours,
    level,
    glucoseReadingsJson,
    hrvReadingsJson,
    refeedingNotes,
    toleranceScore,
    energyScore,
    waterCount,
    llmSummaryText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fasting_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FastingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('target_hours')) {
      context.handle(
        _targetHoursMeta,
        targetHours.isAcceptableOrUnknown(
          data['target_hours']!,
          _targetHoursMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetHoursMeta);
    }
    if (data.containsKey('actual_hours')) {
      context.handle(
        _actualHoursMeta,
        actualHours.isAcceptableOrUnknown(
          data['actual_hours']!,
          _actualHoursMeta,
        ),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('glucose_readings_json')) {
      context.handle(
        _glucoseReadingsJsonMeta,
        glucoseReadingsJson.isAcceptableOrUnknown(
          data['glucose_readings_json']!,
          _glucoseReadingsJsonMeta,
        ),
      );
    }
    if (data.containsKey('hrv_readings_json')) {
      context.handle(
        _hrvReadingsJsonMeta,
        hrvReadingsJson.isAcceptableOrUnknown(
          data['hrv_readings_json']!,
          _hrvReadingsJsonMeta,
        ),
      );
    }
    if (data.containsKey('refeeding_notes')) {
      context.handle(
        _refeedingNotesMeta,
        refeedingNotes.isAcceptableOrUnknown(
          data['refeeding_notes']!,
          _refeedingNotesMeta,
        ),
      );
    }
    if (data.containsKey('tolerance_score')) {
      context.handle(
        _toleranceScoreMeta,
        toleranceScore.isAcceptableOrUnknown(
          data['tolerance_score']!,
          _toleranceScoreMeta,
        ),
      );
    }
    if (data.containsKey('energy_score')) {
      context.handle(
        _energyScoreMeta,
        energyScore.isAcceptableOrUnknown(
          data['energy_score']!,
          _energyScoreMeta,
        ),
      );
    }
    if (data.containsKey('water_count')) {
      context.handle(
        _waterCountMeta,
        waterCount.isAcceptableOrUnknown(data['water_count']!, _waterCountMeta),
      );
    }
    if (data.containsKey('llm_summary_text')) {
      context.handle(
        _llmSummaryTextMeta,
        llmSummaryText.isAcceptableOrUnknown(
          data['llm_summary_text']!,
          _llmSummaryTextMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FastingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FastingSession(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}started_at'],
          )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      targetHours:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}target_hours'],
          )!,
      actualHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}actual_hours'],
      ),
      level:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}level'],
          )!,
      glucoseReadingsJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}glucose_readings_json'],
          )!,
      hrvReadingsJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}hrv_readings_json'],
          )!,
      refeedingNotes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}refeeding_notes'],
          )!,
      toleranceScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tolerance_score'],
      ),
      energyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_score'],
      ),
      waterCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}water_count'],
          )!,
      llmSummaryText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}llm_summary_text'],
          )!,
    );
  }

  @override
  $FastingSessionsTable createAlias(String alias) {
    return $FastingSessionsTable(attachedDatabase, alias);
  }
}

class FastingSession extends DataClass implements Insertable<FastingSession> {
  final int id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final double targetHours;
  final double? actualHours;
  final int level;
  final String glucoseReadingsJson;
  final String hrvReadingsJson;
  final String refeedingNotes;
  final double? toleranceScore;
  final int? energyScore;
  final int waterCount;
  final String llmSummaryText;
  const FastingSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.targetHours,
    this.actualHours,
    required this.level,
    required this.glucoseReadingsJson,
    required this.hrvReadingsJson,
    required this.refeedingNotes,
    this.toleranceScore,
    this.energyScore,
    required this.waterCount,
    required this.llmSummaryText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['target_hours'] = Variable<double>(targetHours);
    if (!nullToAbsent || actualHours != null) {
      map['actual_hours'] = Variable<double>(actualHours);
    }
    map['level'] = Variable<int>(level);
    map['glucose_readings_json'] = Variable<String>(glucoseReadingsJson);
    map['hrv_readings_json'] = Variable<String>(hrvReadingsJson);
    map['refeeding_notes'] = Variable<String>(refeedingNotes);
    if (!nullToAbsent || toleranceScore != null) {
      map['tolerance_score'] = Variable<double>(toleranceScore);
    }
    if (!nullToAbsent || energyScore != null) {
      map['energy_score'] = Variable<int>(energyScore);
    }
    map['water_count'] = Variable<int>(waterCount);
    map['llm_summary_text'] = Variable<String>(llmSummaryText);
    return map;
  }

  FastingSessionsCompanion toCompanion(bool nullToAbsent) {
    return FastingSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt:
          endedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(endedAt),
      targetHours: Value(targetHours),
      actualHours:
          actualHours == null && nullToAbsent
              ? const Value.absent()
              : Value(actualHours),
      level: Value(level),
      glucoseReadingsJson: Value(glucoseReadingsJson),
      hrvReadingsJson: Value(hrvReadingsJson),
      refeedingNotes: Value(refeedingNotes),
      toleranceScore:
          toleranceScore == null && nullToAbsent
              ? const Value.absent()
              : Value(toleranceScore),
      energyScore:
          energyScore == null && nullToAbsent
              ? const Value.absent()
              : Value(energyScore),
      waterCount: Value(waterCount),
      llmSummaryText: Value(llmSummaryText),
    );
  }

  factory FastingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FastingSession(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      targetHours: serializer.fromJson<double>(json['targetHours']),
      actualHours: serializer.fromJson<double?>(json['actualHours']),
      level: serializer.fromJson<int>(json['level']),
      glucoseReadingsJson: serializer.fromJson<String>(
        json['glucoseReadingsJson'],
      ),
      hrvReadingsJson: serializer.fromJson<String>(json['hrvReadingsJson']),
      refeedingNotes: serializer.fromJson<String>(json['refeedingNotes']),
      toleranceScore: serializer.fromJson<double?>(json['toleranceScore']),
      energyScore: serializer.fromJson<int?>(json['energyScore']),
      waterCount: serializer.fromJson<int>(json['waterCount']),
      llmSummaryText: serializer.fromJson<String>(json['llmSummaryText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'targetHours': serializer.toJson<double>(targetHours),
      'actualHours': serializer.toJson<double?>(actualHours),
      'level': serializer.toJson<int>(level),
      'glucoseReadingsJson': serializer.toJson<String>(glucoseReadingsJson),
      'hrvReadingsJson': serializer.toJson<String>(hrvReadingsJson),
      'refeedingNotes': serializer.toJson<String>(refeedingNotes),
      'toleranceScore': serializer.toJson<double?>(toleranceScore),
      'energyScore': serializer.toJson<int?>(energyScore),
      'waterCount': serializer.toJson<int>(waterCount),
      'llmSummaryText': serializer.toJson<String>(llmSummaryText),
    };
  }

  FastingSession copyWith({
    int? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    double? targetHours,
    Value<double?> actualHours = const Value.absent(),
    int? level,
    String? glucoseReadingsJson,
    String? hrvReadingsJson,
    String? refeedingNotes,
    Value<double?> toleranceScore = const Value.absent(),
    Value<int?> energyScore = const Value.absent(),
    int? waterCount,
    String? llmSummaryText,
  }) => FastingSession(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    targetHours: targetHours ?? this.targetHours,
    actualHours: actualHours.present ? actualHours.value : this.actualHours,
    level: level ?? this.level,
    glucoseReadingsJson: glucoseReadingsJson ?? this.glucoseReadingsJson,
    hrvReadingsJson: hrvReadingsJson ?? this.hrvReadingsJson,
    refeedingNotes: refeedingNotes ?? this.refeedingNotes,
    toleranceScore:
        toleranceScore.present ? toleranceScore.value : this.toleranceScore,
    energyScore: energyScore.present ? energyScore.value : this.energyScore,
    waterCount: waterCount ?? this.waterCount,
    llmSummaryText: llmSummaryText ?? this.llmSummaryText,
  );
  FastingSession copyWithCompanion(FastingSessionsCompanion data) {
    return FastingSession(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      targetHours:
          data.targetHours.present ? data.targetHours.value : this.targetHours,
      actualHours:
          data.actualHours.present ? data.actualHours.value : this.actualHours,
      level: data.level.present ? data.level.value : this.level,
      glucoseReadingsJson:
          data.glucoseReadingsJson.present
              ? data.glucoseReadingsJson.value
              : this.glucoseReadingsJson,
      hrvReadingsJson:
          data.hrvReadingsJson.present
              ? data.hrvReadingsJson.value
              : this.hrvReadingsJson,
      refeedingNotes:
          data.refeedingNotes.present
              ? data.refeedingNotes.value
              : this.refeedingNotes,
      toleranceScore:
          data.toleranceScore.present
              ? data.toleranceScore.value
              : this.toleranceScore,
      energyScore:
          data.energyScore.present ? data.energyScore.value : this.energyScore,
      waterCount:
          data.waterCount.present ? data.waterCount.value : this.waterCount,
      llmSummaryText:
          data.llmSummaryText.present
              ? data.llmSummaryText.value
              : this.llmSummaryText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FastingSession(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('targetHours: $targetHours, ')
          ..write('actualHours: $actualHours, ')
          ..write('level: $level, ')
          ..write('glucoseReadingsJson: $glucoseReadingsJson, ')
          ..write('hrvReadingsJson: $hrvReadingsJson, ')
          ..write('refeedingNotes: $refeedingNotes, ')
          ..write('toleranceScore: $toleranceScore, ')
          ..write('energyScore: $energyScore, ')
          ..write('waterCount: $waterCount, ')
          ..write('llmSummaryText: $llmSummaryText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    endedAt,
    targetHours,
    actualHours,
    level,
    glucoseReadingsJson,
    hrvReadingsJson,
    refeedingNotes,
    toleranceScore,
    energyScore,
    waterCount,
    llmSummaryText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FastingSession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.targetHours == this.targetHours &&
          other.actualHours == this.actualHours &&
          other.level == this.level &&
          other.glucoseReadingsJson == this.glucoseReadingsJson &&
          other.hrvReadingsJson == this.hrvReadingsJson &&
          other.refeedingNotes == this.refeedingNotes &&
          other.toleranceScore == this.toleranceScore &&
          other.energyScore == this.energyScore &&
          other.waterCount == this.waterCount &&
          other.llmSummaryText == this.llmSummaryText);
}

class FastingSessionsCompanion extends UpdateCompanion<FastingSession> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<double> targetHours;
  final Value<double?> actualHours;
  final Value<int> level;
  final Value<String> glucoseReadingsJson;
  final Value<String> hrvReadingsJson;
  final Value<String> refeedingNotes;
  final Value<double?> toleranceScore;
  final Value<int?> energyScore;
  final Value<int> waterCount;
  final Value<String> llmSummaryText;
  const FastingSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.targetHours = const Value.absent(),
    this.actualHours = const Value.absent(),
    this.level = const Value.absent(),
    this.glucoseReadingsJson = const Value.absent(),
    this.hrvReadingsJson = const Value.absent(),
    this.refeedingNotes = const Value.absent(),
    this.toleranceScore = const Value.absent(),
    this.energyScore = const Value.absent(),
    this.waterCount = const Value.absent(),
    this.llmSummaryText = const Value.absent(),
  });
  FastingSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required double targetHours,
    this.actualHours = const Value.absent(),
    this.level = const Value.absent(),
    this.glucoseReadingsJson = const Value.absent(),
    this.hrvReadingsJson = const Value.absent(),
    this.refeedingNotes = const Value.absent(),
    this.toleranceScore = const Value.absent(),
    this.energyScore = const Value.absent(),
    this.waterCount = const Value.absent(),
    this.llmSummaryText = const Value.absent(),
  }) : startedAt = Value(startedAt),
       targetHours = Value(targetHours);
  static Insertable<FastingSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<double>? targetHours,
    Expression<double>? actualHours,
    Expression<int>? level,
    Expression<String>? glucoseReadingsJson,
    Expression<String>? hrvReadingsJson,
    Expression<String>? refeedingNotes,
    Expression<double>? toleranceScore,
    Expression<int>? energyScore,
    Expression<int>? waterCount,
    Expression<String>? llmSummaryText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (targetHours != null) 'target_hours': targetHours,
      if (actualHours != null) 'actual_hours': actualHours,
      if (level != null) 'level': level,
      if (glucoseReadingsJson != null)
        'glucose_readings_json': glucoseReadingsJson,
      if (hrvReadingsJson != null) 'hrv_readings_json': hrvReadingsJson,
      if (refeedingNotes != null) 'refeeding_notes': refeedingNotes,
      if (toleranceScore != null) 'tolerance_score': toleranceScore,
      if (energyScore != null) 'energy_score': energyScore,
      if (waterCount != null) 'water_count': waterCount,
      if (llmSummaryText != null) 'llm_summary_text': llmSummaryText,
    });
  }

  FastingSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<double>? targetHours,
    Value<double?>? actualHours,
    Value<int>? level,
    Value<String>? glucoseReadingsJson,
    Value<String>? hrvReadingsJson,
    Value<String>? refeedingNotes,
    Value<double?>? toleranceScore,
    Value<int?>? energyScore,
    Value<int>? waterCount,
    Value<String>? llmSummaryText,
  }) {
    return FastingSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      targetHours: targetHours ?? this.targetHours,
      actualHours: actualHours ?? this.actualHours,
      level: level ?? this.level,
      glucoseReadingsJson: glucoseReadingsJson ?? this.glucoseReadingsJson,
      hrvReadingsJson: hrvReadingsJson ?? this.hrvReadingsJson,
      refeedingNotes: refeedingNotes ?? this.refeedingNotes,
      toleranceScore: toleranceScore ?? this.toleranceScore,
      energyScore: energyScore ?? this.energyScore,
      waterCount: waterCount ?? this.waterCount,
      llmSummaryText: llmSummaryText ?? this.llmSummaryText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (targetHours.present) {
      map['target_hours'] = Variable<double>(targetHours.value);
    }
    if (actualHours.present) {
      map['actual_hours'] = Variable<double>(actualHours.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (glucoseReadingsJson.present) {
      map['glucose_readings_json'] = Variable<String>(
        glucoseReadingsJson.value,
      );
    }
    if (hrvReadingsJson.present) {
      map['hrv_readings_json'] = Variable<String>(hrvReadingsJson.value);
    }
    if (refeedingNotes.present) {
      map['refeeding_notes'] = Variable<String>(refeedingNotes.value);
    }
    if (toleranceScore.present) {
      map['tolerance_score'] = Variable<double>(toleranceScore.value);
    }
    if (energyScore.present) {
      map['energy_score'] = Variable<int>(energyScore.value);
    }
    if (waterCount.present) {
      map['water_count'] = Variable<int>(waterCount.value);
    }
    if (llmSummaryText.present) {
      map['llm_summary_text'] = Variable<String>(llmSummaryText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FastingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('targetHours: $targetHours, ')
          ..write('actualHours: $actualHours, ')
          ..write('level: $level, ')
          ..write('glucoseReadingsJson: $glucoseReadingsJson, ')
          ..write('hrvReadingsJson: $hrvReadingsJson, ')
          ..write('refeedingNotes: $refeedingNotes, ')
          ..write('toleranceScore: $toleranceScore, ')
          ..write('energyScore: $energyScore, ')
          ..write('waterCount: $waterCount, ')
          ..write('llmSummaryText: $llmSummaryText')
          ..write(')'))
        .toString();
  }
}

class $BiomarkersTable extends Biomarkers
    with TableInfo<$BiomarkersTable, Biomarker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BiomarkersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valuesJsonMeta = const VerificationMeta(
    'valuesJson',
  );
  @override
  late final GeneratedColumn<String> valuesJson = GeneratedColumn<String>(
    'values_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, type, valuesJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'biomarkers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Biomarker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('values_json')) {
      context.handle(
        _valuesJsonMeta,
        valuesJson.isAcceptableOrUnknown(data['values_json']!, _valuesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valuesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Biomarker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Biomarker(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      valuesJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}values_json'],
          )!,
    );
  }

  @override
  $BiomarkersTable createAlias(String alias) {
    return $BiomarkersTable(attachedDatabase, alias);
  }
}

class Biomarker extends DataClass implements Insertable<Biomarker> {
  final int id;
  final DateTime date;
  final String type;
  final String valuesJson;
  const Biomarker({
    required this.id,
    required this.date,
    required this.type,
    required this.valuesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['values_json'] = Variable<String>(valuesJson);
    return map;
  }

  BiomarkersCompanion toCompanion(bool nullToAbsent) {
    return BiomarkersCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      valuesJson: Value(valuesJson),
    );
  }

  factory Biomarker.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Biomarker(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      valuesJson: serializer.fromJson<String>(json['valuesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'valuesJson': serializer.toJson<String>(valuesJson),
    };
  }

  Biomarker copyWith({
    int? id,
    DateTime? date,
    String? type,
    String? valuesJson,
  }) => Biomarker(
    id: id ?? this.id,
    date: date ?? this.date,
    type: type ?? this.type,
    valuesJson: valuesJson ?? this.valuesJson,
  );
  Biomarker copyWithCompanion(BiomarkersCompanion data) {
    return Biomarker(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      valuesJson:
          data.valuesJson.present ? data.valuesJson.value : this.valuesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Biomarker(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('valuesJson: $valuesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, type, valuesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Biomarker &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.valuesJson == this.valuesJson);
}

class BiomarkersCompanion extends UpdateCompanion<Biomarker> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<String> valuesJson;
  const BiomarkersCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.valuesJson = const Value.absent(),
  });
  BiomarkersCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String type,
    required String valuesJson,
  }) : date = Value(date),
       type = Value(type),
       valuesJson = Value(valuesJson);
  static Insertable<Biomarker> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<String>? valuesJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (valuesJson != null) 'values_json': valuesJson,
    });
  }

  BiomarkersCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? type,
    Value<String>? valuesJson,
  }) {
    return BiomarkersCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      valuesJson: valuesJson ?? this.valuesJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (valuesJson.present) {
      map['values_json'] = Variable<String>(valuesJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BiomarkersCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('valuesJson: $valuesJson')
          ..write(')'))
        .toString();
  }
}

class $ConditioningSessionsTable extends ConditioningSessions
    with TableInfo<$ConditioningSessionsTable, ConditioningSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConditioningSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    type,
    durationSeconds,
    temperature,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conditioning_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConditioningSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConditioningSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConditioningSession(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      durationSeconds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}duration_seconds'],
          )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      notes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notes'],
          )!,
    );
  }

  @override
  $ConditioningSessionsTable createAlias(String alias) {
    return $ConditioningSessionsTable(attachedDatabase, alias);
  }
}

class ConditioningSession extends DataClass
    implements Insertable<ConditioningSession> {
  final int id;
  final DateTime date;
  final String type;
  final int durationSeconds;
  final double? temperature;
  final String notes;
  const ConditioningSession({
    required this.id,
    required this.date,
    required this.type,
    required this.durationSeconds,
    this.temperature,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    map['notes'] = Variable<String>(notes);
    return map;
  }

  ConditioningSessionsCompanion toCompanion(bool nullToAbsent) {
    return ConditioningSessionsCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      durationSeconds: Value(durationSeconds),
      temperature:
          temperature == null && nullToAbsent
              ? const Value.absent()
              : Value(temperature),
      notes: Value(notes),
    );
  }

  factory ConditioningSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConditioningSession(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      temperature: serializer.fromJson<double?>(json['temperature']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'temperature': serializer.toJson<double?>(temperature),
      'notes': serializer.toJson<String>(notes),
    };
  }

  ConditioningSession copyWith({
    int? id,
    DateTime? date,
    String? type,
    int? durationSeconds,
    Value<double?> temperature = const Value.absent(),
    String? notes,
  }) => ConditioningSession(
    id: id ?? this.id,
    date: date ?? this.date,
    type: type ?? this.type,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    temperature: temperature.present ? temperature.value : this.temperature,
    notes: notes ?? this.notes,
  );
  ConditioningSession copyWithCompanion(ConditioningSessionsCompanion data) {
    return ConditioningSession(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      durationSeconds:
          data.durationSeconds.present
              ? data.durationSeconds.value
              : this.durationSeconds,
      temperature:
          data.temperature.present ? data.temperature.value : this.temperature,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConditioningSession(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('temperature: $temperature, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, type, durationSeconds, temperature, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConditioningSession &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.durationSeconds == this.durationSeconds &&
          other.temperature == this.temperature &&
          other.notes == this.notes);
}

class ConditioningSessionsCompanion
    extends UpdateCompanion<ConditioningSession> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<int> durationSeconds;
  final Value<double?> temperature;
  final Value<String> notes;
  const ConditioningSessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.temperature = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ConditioningSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String type,
    required int durationSeconds,
    this.temperature = const Value.absent(),
    this.notes = const Value.absent(),
  }) : date = Value(date),
       type = Value(type),
       durationSeconds = Value(durationSeconds);
  static Insertable<ConditioningSession> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<int>? durationSeconds,
    Expression<double>? temperature,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (temperature != null) 'temperature': temperature,
      if (notes != null) 'notes': notes,
    });
  }

  ConditioningSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? type,
    Value<int>? durationSeconds,
    Value<double?>? temperature,
    Value<String>? notes,
  }) {
    return ConditioningSessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      temperature: temperature ?? this.temperature,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConditioningSessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('temperature: $temperature, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $LlmReportsTable extends LlmReports
    with TableInfo<$LlmReportsTable, LlmReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LlmReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptTemplateMeta = const VerificationMeta(
    'promptTemplate',
  );
  @override
  late final GeneratedColumn<String> promptTemplate = GeneratedColumn<String>(
    'prompt_template',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextDataJsonMeta = const VerificationMeta(
    'contextDataJson',
  );
  @override
  late final GeneratedColumn<String> contextDataJson = GeneratedColumn<String>(
    'context_data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outputTextMeta = const VerificationMeta(
    'outputText',
  );
  @override
  late final GeneratedColumn<String> outputText = GeneratedColumn<String>(
    'output_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    generatedAt,
    type,
    promptTemplate,
    contextDataJson,
    outputText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'llm_reports';
  @override
  VerificationContext validateIntegrity(
    Insertable<LlmReport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('prompt_template')) {
      context.handle(
        _promptTemplateMeta,
        promptTemplate.isAcceptableOrUnknown(
          data['prompt_template']!,
          _promptTemplateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_promptTemplateMeta);
    }
    if (data.containsKey('context_data_json')) {
      context.handle(
        _contextDataJsonMeta,
        contextDataJson.isAcceptableOrUnknown(
          data['context_data_json']!,
          _contextDataJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contextDataJsonMeta);
    }
    if (data.containsKey('output_text')) {
      context.handle(
        _outputTextMeta,
        outputText.isAcceptableOrUnknown(data['output_text']!, _outputTextMeta),
      );
    } else if (isInserting) {
      context.missing(_outputTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LlmReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LlmReport(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      generatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}generated_at'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      promptTemplate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}prompt_template'],
          )!,
      contextDataJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}context_data_json'],
          )!,
      outputText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}output_text'],
          )!,
    );
  }

  @override
  $LlmReportsTable createAlias(String alias) {
    return $LlmReportsTable(attachedDatabase, alias);
  }
}

class LlmReport extends DataClass implements Insertable<LlmReport> {
  final int id;
  final DateTime generatedAt;
  final String type;
  final String promptTemplate;
  final String contextDataJson;
  final String outputText;
  const LlmReport({
    required this.id,
    required this.generatedAt,
    required this.type,
    required this.promptTemplate,
    required this.contextDataJson,
    required this.outputText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['type'] = Variable<String>(type);
    map['prompt_template'] = Variable<String>(promptTemplate);
    map['context_data_json'] = Variable<String>(contextDataJson);
    map['output_text'] = Variable<String>(outputText);
    return map;
  }

  LlmReportsCompanion toCompanion(bool nullToAbsent) {
    return LlmReportsCompanion(
      id: Value(id),
      generatedAt: Value(generatedAt),
      type: Value(type),
      promptTemplate: Value(promptTemplate),
      contextDataJson: Value(contextDataJson),
      outputText: Value(outputText),
    );
  }

  factory LlmReport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LlmReport(
      id: serializer.fromJson<int>(json['id']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      type: serializer.fromJson<String>(json['type']),
      promptTemplate: serializer.fromJson<String>(json['promptTemplate']),
      contextDataJson: serializer.fromJson<String>(json['contextDataJson']),
      outputText: serializer.fromJson<String>(json['outputText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'type': serializer.toJson<String>(type),
      'promptTemplate': serializer.toJson<String>(promptTemplate),
      'contextDataJson': serializer.toJson<String>(contextDataJson),
      'outputText': serializer.toJson<String>(outputText),
    };
  }

  LlmReport copyWith({
    int? id,
    DateTime? generatedAt,
    String? type,
    String? promptTemplate,
    String? contextDataJson,
    String? outputText,
  }) => LlmReport(
    id: id ?? this.id,
    generatedAt: generatedAt ?? this.generatedAt,
    type: type ?? this.type,
    promptTemplate: promptTemplate ?? this.promptTemplate,
    contextDataJson: contextDataJson ?? this.contextDataJson,
    outputText: outputText ?? this.outputText,
  );
  LlmReport copyWithCompanion(LlmReportsCompanion data) {
    return LlmReport(
      id: data.id.present ? data.id.value : this.id,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      type: data.type.present ? data.type.value : this.type,
      promptTemplate:
          data.promptTemplate.present
              ? data.promptTemplate.value
              : this.promptTemplate,
      contextDataJson:
          data.contextDataJson.present
              ? data.contextDataJson.value
              : this.contextDataJson,
      outputText:
          data.outputText.present ? data.outputText.value : this.outputText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LlmReport(')
          ..write('id: $id, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('type: $type, ')
          ..write('promptTemplate: $promptTemplate, ')
          ..write('contextDataJson: $contextDataJson, ')
          ..write('outputText: $outputText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    generatedAt,
    type,
    promptTemplate,
    contextDataJson,
    outputText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LlmReport &&
          other.id == this.id &&
          other.generatedAt == this.generatedAt &&
          other.type == this.type &&
          other.promptTemplate == this.promptTemplate &&
          other.contextDataJson == this.contextDataJson &&
          other.outputText == this.outputText);
}

class LlmReportsCompanion extends UpdateCompanion<LlmReport> {
  final Value<int> id;
  final Value<DateTime> generatedAt;
  final Value<String> type;
  final Value<String> promptTemplate;
  final Value<String> contextDataJson;
  final Value<String> outputText;
  const LlmReportsCompanion({
    this.id = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.type = const Value.absent(),
    this.promptTemplate = const Value.absent(),
    this.contextDataJson = const Value.absent(),
    this.outputText = const Value.absent(),
  });
  LlmReportsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime generatedAt,
    required String type,
    required String promptTemplate,
    required String contextDataJson,
    required String outputText,
  }) : generatedAt = Value(generatedAt),
       type = Value(type),
       promptTemplate = Value(promptTemplate),
       contextDataJson = Value(contextDataJson),
       outputText = Value(outputText);
  static Insertable<LlmReport> custom({
    Expression<int>? id,
    Expression<DateTime>? generatedAt,
    Expression<String>? type,
    Expression<String>? promptTemplate,
    Expression<String>? contextDataJson,
    Expression<String>? outputText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (type != null) 'type': type,
      if (promptTemplate != null) 'prompt_template': promptTemplate,
      if (contextDataJson != null) 'context_data_json': contextDataJson,
      if (outputText != null) 'output_text': outputText,
    });
  }

  LlmReportsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? generatedAt,
    Value<String>? type,
    Value<String>? promptTemplate,
    Value<String>? contextDataJson,
    Value<String>? outputText,
  }) {
    return LlmReportsCompanion(
      id: id ?? this.id,
      generatedAt: generatedAt ?? this.generatedAt,
      type: type ?? this.type,
      promptTemplate: promptTemplate ?? this.promptTemplate,
      contextDataJson: contextDataJson ?? this.contextDataJson,
      outputText: outputText ?? this.outputText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (promptTemplate.present) {
      map['prompt_template'] = Variable<String>(promptTemplate.value);
    }
    if (contextDataJson.present) {
      map['context_data_json'] = Variable<String>(contextDataJson.value);
    }
    if (outputText.present) {
      map['output_text'] = Variable<String>(outputText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LlmReportsCompanion(')
          ..write('id: $id, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('type: $type, ')
          ..write('promptTemplate: $promptTemplate, ')
          ..write('contextDataJson: $contextDataJson, ')
          ..write('outputText: $outputText')
          ..write(')'))
        .toString();
  }
}

class $ProgressionHistoryTable extends ProgressionHistory
    with TableInfo<$ProgressionHistoryTable, ProgressionHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressionHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromLevelMeta = const VerificationMeta(
    'fromLevel',
  );
  @override
  late final GeneratedColumn<int> fromLevel = GeneratedColumn<int>(
    'from_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toLevelMeta = const VerificationMeta(
    'toLevel',
  );
  @override
  late final GeneratedColumn<int> toLevel = GeneratedColumn<int>(
    'to_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criteriaMetJsonMeta = const VerificationMeta(
    'criteriaMetJson',
  );
  @override
  late final GeneratedColumn<String> criteriaMetJson = GeneratedColumn<String>(
    'criteria_met_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseId,
    date,
    fromLevel,
    toLevel,
    criteriaMetJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progression_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressionHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('from_level')) {
      context.handle(
        _fromLevelMeta,
        fromLevel.isAcceptableOrUnknown(data['from_level']!, _fromLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_fromLevelMeta);
    }
    if (data.containsKey('to_level')) {
      context.handle(
        _toLevelMeta,
        toLevel.isAcceptableOrUnknown(data['to_level']!, _toLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_toLevelMeta);
    }
    if (data.containsKey('criteria_met_json')) {
      context.handle(
        _criteriaMetJsonMeta,
        criteriaMetJson.isAcceptableOrUnknown(
          data['criteria_met_json']!,
          _criteriaMetJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressionHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressionHistoryData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      exerciseId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}exercise_id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      fromLevel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}from_level'],
          )!,
      toLevel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}to_level'],
          )!,
      criteriaMetJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}criteria_met_json'],
          )!,
    );
  }

  @override
  $ProgressionHistoryTable createAlias(String alias) {
    return $ProgressionHistoryTable(attachedDatabase, alias);
  }
}

class ProgressionHistoryData extends DataClass
    implements Insertable<ProgressionHistoryData> {
  final int id;
  final int exerciseId;
  final DateTime date;
  final int fromLevel;
  final int toLevel;
  final String criteriaMetJson;
  const ProgressionHistoryData({
    required this.id,
    required this.exerciseId,
    required this.date,
    required this.fromLevel,
    required this.toLevel,
    required this.criteriaMetJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['date'] = Variable<DateTime>(date);
    map['from_level'] = Variable<int>(fromLevel);
    map['to_level'] = Variable<int>(toLevel);
    map['criteria_met_json'] = Variable<String>(criteriaMetJson);
    return map;
  }

  ProgressionHistoryCompanion toCompanion(bool nullToAbsent) {
    return ProgressionHistoryCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      date: Value(date),
      fromLevel: Value(fromLevel),
      toLevel: Value(toLevel),
      criteriaMetJson: Value(criteriaMetJson),
    );
  }

  factory ProgressionHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressionHistoryData(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      date: serializer.fromJson<DateTime>(json['date']),
      fromLevel: serializer.fromJson<int>(json['fromLevel']),
      toLevel: serializer.fromJson<int>(json['toLevel']),
      criteriaMetJson: serializer.fromJson<String>(json['criteriaMetJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'date': serializer.toJson<DateTime>(date),
      'fromLevel': serializer.toJson<int>(fromLevel),
      'toLevel': serializer.toJson<int>(toLevel),
      'criteriaMetJson': serializer.toJson<String>(criteriaMetJson),
    };
  }

  ProgressionHistoryData copyWith({
    int? id,
    int? exerciseId,
    DateTime? date,
    int? fromLevel,
    int? toLevel,
    String? criteriaMetJson,
  }) => ProgressionHistoryData(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    date: date ?? this.date,
    fromLevel: fromLevel ?? this.fromLevel,
    toLevel: toLevel ?? this.toLevel,
    criteriaMetJson: criteriaMetJson ?? this.criteriaMetJson,
  );
  ProgressionHistoryData copyWithCompanion(ProgressionHistoryCompanion data) {
    return ProgressionHistoryData(
      id: data.id.present ? data.id.value : this.id,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      date: data.date.present ? data.date.value : this.date,
      fromLevel: data.fromLevel.present ? data.fromLevel.value : this.fromLevel,
      toLevel: data.toLevel.present ? data.toLevel.value : this.toLevel,
      criteriaMetJson:
          data.criteriaMetJson.present
              ? data.criteriaMetJson.value
              : this.criteriaMetJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressionHistoryData(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('date: $date, ')
          ..write('fromLevel: $fromLevel, ')
          ..write('toLevel: $toLevel, ')
          ..write('criteriaMetJson: $criteriaMetJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, exerciseId, date, fromLevel, toLevel, criteriaMetJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressionHistoryData &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.date == this.date &&
          other.fromLevel == this.fromLevel &&
          other.toLevel == this.toLevel &&
          other.criteriaMetJson == this.criteriaMetJson);
}

class ProgressionHistoryCompanion
    extends UpdateCompanion<ProgressionHistoryData> {
  final Value<int> id;
  final Value<int> exerciseId;
  final Value<DateTime> date;
  final Value<int> fromLevel;
  final Value<int> toLevel;
  final Value<String> criteriaMetJson;
  const ProgressionHistoryCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.date = const Value.absent(),
    this.fromLevel = const Value.absent(),
    this.toLevel = const Value.absent(),
    this.criteriaMetJson = const Value.absent(),
  });
  ProgressionHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseId,
    required DateTime date,
    required int fromLevel,
    required int toLevel,
    this.criteriaMetJson = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       date = Value(date),
       fromLevel = Value(fromLevel),
       toLevel = Value(toLevel);
  static Insertable<ProgressionHistoryData> custom({
    Expression<int>? id,
    Expression<int>? exerciseId,
    Expression<DateTime>? date,
    Expression<int>? fromLevel,
    Expression<int>? toLevel,
    Expression<String>? criteriaMetJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (date != null) 'date': date,
      if (fromLevel != null) 'from_level': fromLevel,
      if (toLevel != null) 'to_level': toLevel,
      if (criteriaMetJson != null) 'criteria_met_json': criteriaMetJson,
    });
  }

  ProgressionHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? exerciseId,
    Value<DateTime>? date,
    Value<int>? fromLevel,
    Value<int>? toLevel,
    Value<String>? criteriaMetJson,
  }) {
    return ProgressionHistoryCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      date: date ?? this.date,
      fromLevel: fromLevel ?? this.fromLevel,
      toLevel: toLevel ?? this.toLevel,
      criteriaMetJson: criteriaMetJson ?? this.criteriaMetJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (fromLevel.present) {
      map['from_level'] = Variable<int>(fromLevel.value);
    }
    if (toLevel.present) {
      map['to_level'] = Variable<int>(toLevel.value);
    }
    if (criteriaMetJson.present) {
      map['criteria_met_json'] = Variable<String>(criteriaMetJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressionHistoryCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('date: $date, ')
          ..write('fromLevel: $fromLevel, ')
          ..write('toLevel: $toLevel, ')
          ..write('criteriaMetJson: $criteriaMetJson')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingsJsonMeta = const VerificationMeta(
    'settingsJson',
  );
  @override
  late final GeneratedColumn<String> settingsJson = GeneratedColumn<String>(
    'settings_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, settingsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('settings_json')) {
      context.handle(
        _settingsJsonMeta,
        settingsJson.isAcceptableOrUnknown(
          data['settings_json']!,
          _settingsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      settingsJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}settings_json'],
          )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final int id;
  final DateTime createdAt;
  final String settingsJson;
  const UserSetting({
    required this.id,
    required this.createdAt,
    required this.settingsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['settings_json'] = Variable<String>(settingsJson);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      settingsJson: Value(settingsJson),
    );
  }

  factory UserSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      settingsJson: serializer.fromJson<String>(json['settingsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'settingsJson': serializer.toJson<String>(settingsJson),
    };
  }

  UserSetting copyWith({int? id, DateTime? createdAt, String? settingsJson}) =>
      UserSetting(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        settingsJson: settingsJson ?? this.settingsJson,
      );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      settingsJson:
          data.settingsJson.present
              ? data.settingsJson.value
              : this.settingsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('settingsJson: $settingsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, settingsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.settingsJson == this.settingsJson);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> settingsJson;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.settingsJson = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    this.settingsJson = const Value.absent(),
  }) : createdAt = Value(createdAt);
  static Insertable<UserSetting> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? settingsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (settingsJson != null) 'settings_json': settingsJson,
    });
  }

  UserSettingsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<String>? settingsJson,
  }) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      settingsJson: settingsJson ?? this.settingsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (settingsJson.present) {
      map['settings_json'] = Variable<String>(settingsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('settingsJson: $settingsJson')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthYearMeta = const VerificationMeta(
    'birthYear',
  );
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
    'birth_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trainingTierMeta = const VerificationMeta(
    'trainingTier',
  );
  @override
  late final GeneratedColumn<String> trainingTier = GeneratedColumn<String>(
    'training_tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxPushupsMeta = const VerificationMeta(
    'maxPushups',
  );
  @override
  late final GeneratedColumn<int> maxPushups = GeneratedColumn<int>(
    'max_pushups',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxSquatsMeta = const VerificationMeta(
    'maxSquats',
  );
  @override
  late final GeneratedColumn<int> maxSquats = GeneratedColumn<int>(
    'max_squats',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plankSecondsMeta = const VerificationMeta(
    'plankSeconds',
  );
  @override
  late final GeneratedColumn<int> plankSeconds = GeneratedColumn<int>(
    'plank_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restingHrMeta = const VerificationMeta(
    'restingHr',
  );
  @override
  late final GeneratedColumn<int> restingHr = GeneratedColumn<int>(
    'resting_hr',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    name,
    sex,
    birthYear,
    heightCm,
    weightKg,
    trainingTier,
    equipment,
    maxPushups,
    maxSquats,
    plankSeconds,
    restingHr,
    onboardingComplete,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('birth_year')) {
      context.handle(
        _birthYearMeta,
        birthYear.isAcceptableOrUnknown(data['birth_year']!, _birthYearMeta),
      );
    } else if (isInserting) {
      context.missing(_birthYearMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('training_tier')) {
      context.handle(
        _trainingTierMeta,
        trainingTier.isAcceptableOrUnknown(
          data['training_tier']!,
          _trainingTierMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trainingTierMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('max_pushups')) {
      context.handle(
        _maxPushupsMeta,
        maxPushups.isAcceptableOrUnknown(data['max_pushups']!, _maxPushupsMeta),
      );
    }
    if (data.containsKey('max_squats')) {
      context.handle(
        _maxSquatsMeta,
        maxSquats.isAcceptableOrUnknown(data['max_squats']!, _maxSquatsMeta),
      );
    }
    if (data.containsKey('plank_seconds')) {
      context.handle(
        _plankSecondsMeta,
        plankSeconds.isAcceptableOrUnknown(
          data['plank_seconds']!,
          _plankSecondsMeta,
        ),
      );
    }
    if (data.containsKey('resting_hr')) {
      context.handle(
        _restingHrMeta,
        restingHr.isAcceptableOrUnknown(data['resting_hr']!, _restingHrMeta),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      sex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sex'],
          )!,
      birthYear:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}birth_year'],
          )!,
      heightCm:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}height_cm'],
          )!,
      weightKg:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}weight_kg'],
          )!,
      trainingTier:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}training_tier'],
          )!,
      equipment:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}equipment'],
          )!,
      maxPushups: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_pushups'],
      ),
      maxSquats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_squats'],
      ),
      plankSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plank_seconds'],
      ),
      restingHr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resting_hr'],
      ),
      onboardingComplete:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}onboarding_complete'],
          )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String sex;
  final int birthYear;
  final double heightCm;
  final double weightKg;
  final String trainingTier;
  final String equipment;
  final int? maxPushups;
  final int? maxSquats;
  final int? plankSeconds;
  final int? restingHr;
  final bool onboardingComplete;
  const UserProfile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.sex,
    required this.birthYear,
    required this.heightCm,
    required this.weightKg,
    required this.trainingTier,
    required this.equipment,
    this.maxPushups,
    this.maxSquats,
    this.plankSeconds,
    this.restingHr,
    required this.onboardingComplete,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['name'] = Variable<String>(name);
    map['sex'] = Variable<String>(sex);
    map['birth_year'] = Variable<int>(birthYear);
    map['height_cm'] = Variable<double>(heightCm);
    map['weight_kg'] = Variable<double>(weightKg);
    map['training_tier'] = Variable<String>(trainingTier);
    map['equipment'] = Variable<String>(equipment);
    if (!nullToAbsent || maxPushups != null) {
      map['max_pushups'] = Variable<int>(maxPushups);
    }
    if (!nullToAbsent || maxSquats != null) {
      map['max_squats'] = Variable<int>(maxSquats);
    }
    if (!nullToAbsent || plankSeconds != null) {
      map['plank_seconds'] = Variable<int>(plankSeconds);
    }
    if (!nullToAbsent || restingHr != null) {
      map['resting_hr'] = Variable<int>(restingHr);
    }
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      name: Value(name),
      sex: Value(sex),
      birthYear: Value(birthYear),
      heightCm: Value(heightCm),
      weightKg: Value(weightKg),
      trainingTier: Value(trainingTier),
      equipment: Value(equipment),
      maxPushups:
          maxPushups == null && nullToAbsent
              ? const Value.absent()
              : Value(maxPushups),
      maxSquats:
          maxSquats == null && nullToAbsent
              ? const Value.absent()
              : Value(maxSquats),
      plankSeconds:
          plankSeconds == null && nullToAbsent
              ? const Value.absent()
              : Value(plankSeconds),
      restingHr:
          restingHr == null && nullToAbsent
              ? const Value.absent()
              : Value(restingHr),
      onboardingComplete: Value(onboardingComplete),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      name: serializer.fromJson<String>(json['name']),
      sex: serializer.fromJson<String>(json['sex']),
      birthYear: serializer.fromJson<int>(json['birthYear']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      trainingTier: serializer.fromJson<String>(json['trainingTier']),
      equipment: serializer.fromJson<String>(json['equipment']),
      maxPushups: serializer.fromJson<int?>(json['maxPushups']),
      maxSquats: serializer.fromJson<int?>(json['maxSquats']),
      plankSeconds: serializer.fromJson<int?>(json['plankSeconds']),
      restingHr: serializer.fromJson<int?>(json['restingHr']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'name': serializer.toJson<String>(name),
      'sex': serializer.toJson<String>(sex),
      'birthYear': serializer.toJson<int>(birthYear),
      'heightCm': serializer.toJson<double>(heightCm),
      'weightKg': serializer.toJson<double>(weightKg),
      'trainingTier': serializer.toJson<String>(trainingTier),
      'equipment': serializer.toJson<String>(equipment),
      'maxPushups': serializer.toJson<int?>(maxPushups),
      'maxSquats': serializer.toJson<int?>(maxSquats),
      'plankSeconds': serializer.toJson<int?>(plankSeconds),
      'restingHr': serializer.toJson<int?>(restingHr),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
    };
  }

  UserProfile copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? sex,
    int? birthYear,
    double? heightCm,
    double? weightKg,
    String? trainingTier,
    String? equipment,
    Value<int?> maxPushups = const Value.absent(),
    Value<int?> maxSquats = const Value.absent(),
    Value<int?> plankSeconds = const Value.absent(),
    Value<int?> restingHr = const Value.absent(),
    bool? onboardingComplete,
  }) => UserProfile(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    name: name ?? this.name,
    sex: sex ?? this.sex,
    birthYear: birthYear ?? this.birthYear,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    trainingTier: trainingTier ?? this.trainingTier,
    equipment: equipment ?? this.equipment,
    maxPushups: maxPushups.present ? maxPushups.value : this.maxPushups,
    maxSquats: maxSquats.present ? maxSquats.value : this.maxSquats,
    plankSeconds: plankSeconds.present ? plankSeconds.value : this.plankSeconds,
    restingHr: restingHr.present ? restingHr.value : this.restingHr,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      name: data.name.present ? data.name.value : this.name,
      sex: data.sex.present ? data.sex.value : this.sex,
      birthYear: data.birthYear.present ? data.birthYear.value : this.birthYear,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      trainingTier:
          data.trainingTier.present
              ? data.trainingTier.value
              : this.trainingTier,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      maxPushups:
          data.maxPushups.present ? data.maxPushups.value : this.maxPushups,
      maxSquats: data.maxSquats.present ? data.maxSquats.value : this.maxSquats,
      plankSeconds:
          data.plankSeconds.present
              ? data.plankSeconds.value
              : this.plankSeconds,
      restingHr: data.restingHr.present ? data.restingHr.value : this.restingHr,
      onboardingComplete:
          data.onboardingComplete.present
              ? data.onboardingComplete.value
              : this.onboardingComplete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('sex: $sex, ')
          ..write('birthYear: $birthYear, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('trainingTier: $trainingTier, ')
          ..write('equipment: $equipment, ')
          ..write('maxPushups: $maxPushups, ')
          ..write('maxSquats: $maxSquats, ')
          ..write('plankSeconds: $plankSeconds, ')
          ..write('restingHr: $restingHr, ')
          ..write('onboardingComplete: $onboardingComplete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    name,
    sex,
    birthYear,
    heightCm,
    weightKg,
    trainingTier,
    equipment,
    maxPushups,
    maxSquats,
    plankSeconds,
    restingHr,
    onboardingComplete,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.name == this.name &&
          other.sex == this.sex &&
          other.birthYear == this.birthYear &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.trainingTier == this.trainingTier &&
          other.equipment == this.equipment &&
          other.maxPushups == this.maxPushups &&
          other.maxSquats == this.maxSquats &&
          other.plankSeconds == this.plankSeconds &&
          other.restingHr == this.restingHr &&
          other.onboardingComplete == this.onboardingComplete);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> name;
  final Value<String> sex;
  final Value<int> birthYear;
  final Value<double> heightCm;
  final Value<double> weightKg;
  final Value<String> trainingTier;
  final Value<String> equipment;
  final Value<int?> maxPushups;
  final Value<int?> maxSquats;
  final Value<int?> plankSeconds;
  final Value<int?> restingHr;
  final Value<bool> onboardingComplete;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.trainingTier = const Value.absent(),
    this.equipment = const Value.absent(),
    this.maxPushups = const Value.absent(),
    this.maxSquats = const Value.absent(),
    this.plankSeconds = const Value.absent(),
    this.restingHr = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.name = const Value.absent(),
    required String sex,
    required int birthYear,
    required double heightCm,
    required double weightKg,
    required String trainingTier,
    required String equipment,
    this.maxPushups = const Value.absent(),
    this.maxSquats = const Value.absent(),
    this.plankSeconds = const Value.absent(),
    this.restingHr = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       sex = Value(sex),
       birthYear = Value(birthYear),
       heightCm = Value(heightCm),
       weightKg = Value(weightKg),
       trainingTier = Value(trainingTier),
       equipment = Value(equipment);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? name,
    Expression<String>? sex,
    Expression<int>? birthYear,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<String>? trainingTier,
    Expression<String>? equipment,
    Expression<int>? maxPushups,
    Expression<int>? maxSquats,
    Expression<int>? plankSeconds,
    Expression<int>? restingHr,
    Expression<bool>? onboardingComplete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (name != null) 'name': name,
      if (sex != null) 'sex': sex,
      if (birthYear != null) 'birth_year': birthYear,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (trainingTier != null) 'training_tier': trainingTier,
      if (equipment != null) 'equipment': equipment,
      if (maxPushups != null) 'max_pushups': maxPushups,
      if (maxSquats != null) 'max_squats': maxSquats,
      if (plankSeconds != null) 'plank_seconds': plankSeconds,
      if (restingHr != null) 'resting_hr': restingHr,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? name,
    Value<String>? sex,
    Value<int>? birthYear,
    Value<double>? heightCm,
    Value<double>? weightKg,
    Value<String>? trainingTier,
    Value<String>? equipment,
    Value<int?>? maxPushups,
    Value<int?>? maxSquats,
    Value<int?>? plankSeconds,
    Value<int?>? restingHr,
    Value<bool>? onboardingComplete,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      birthYear: birthYear ?? this.birthYear,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      trainingTier: trainingTier ?? this.trainingTier,
      equipment: equipment ?? this.equipment,
      maxPushups: maxPushups ?? this.maxPushups,
      maxSquats: maxSquats ?? this.maxSquats,
      plankSeconds: plankSeconds ?? this.plankSeconds,
      restingHr: restingHr ?? this.restingHr,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (birthYear.present) {
      map['birth_year'] = Variable<int>(birthYear.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (trainingTier.present) {
      map['training_tier'] = Variable<String>(trainingTier.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (maxPushups.present) {
      map['max_pushups'] = Variable<int>(maxPushups.value);
    }
    if (maxSquats.present) {
      map['max_squats'] = Variable<int>(maxSquats.value);
    }
    if (plankSeconds.present) {
      map['plank_seconds'] = Variable<int>(plankSeconds.value);
    }
    if (restingHr.present) {
      map['resting_hr'] = Variable<int>(restingHr.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('sex: $sex, ')
          ..write('birthYear: $birthYear, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('trainingTier: $trainingTier, ')
          ..write('equipment: $equipment, ')
          ..write('maxPushups: $maxPushups, ')
          ..write('maxSquats: $maxSquats, ')
          ..write('plankSeconds: $plankSeconds, ')
          ..write('restingHr: $restingHr, ')
          ..write('onboardingComplete: $onboardingComplete')
          ..write(')'))
        .toString();
  }
}

class $MealLogsTable extends MealLogs with TableInfo<$MealLogsTable, MealLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTimeMeta = const VerificationMeta(
    'mealTime',
  );
  @override
  late final GeneratedColumn<DateTime> mealTime = GeneratedColumn<DateTime>(
    'meal_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinEstimateMeta = const VerificationMeta(
    'proteinEstimate',
  );
  @override
  late final GeneratedColumn<String> proteinEstimate = GeneratedColumn<String>(
    'protein_estimate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feelingMeta = const VerificationMeta(
    'feeling',
  );
  @override
  late final GeneratedColumn<String> feeling = GeneratedColumn<String>(
    'feeling',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _carbEstimateMeta = const VerificationMeta(
    'carbEstimate',
  );
  @override
  late final GeneratedColumn<double> carbEstimate = GeneratedColumn<double>(
    'carb_estimate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatEstimateMeta = const VerificationMeta(
    'fatEstimate',
  );
  @override
  late final GeneratedColumn<double> fatEstimate = GeneratedColumn<double>(
    'fat_estimate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fiberEstimateMeta = const VerificationMeta(
    'fiberEstimate',
  );
  @override
  late final GeneratedColumn<double> fiberEstimate = GeneratedColumn<double>(
    'fiber_estimate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesEstimateMeta = const VerificationMeta(
    'caloriesEstimate',
  );
  @override
  late final GeneratedColumn<double> caloriesEstimate = GeneratedColumn<double>(
    'calories_estimate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    mealTime,
    description,
    proteinEstimate,
    feeling,
    notes,
    carbEstimate,
    fatEstimate,
    fiberEstimate,
    caloriesEstimate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('meal_time')) {
      context.handle(
        _mealTimeMeta,
        mealTime.isAcceptableOrUnknown(data['meal_time']!, _mealTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTimeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('protein_estimate')) {
      context.handle(
        _proteinEstimateMeta,
        proteinEstimate.isAcceptableOrUnknown(
          data['protein_estimate']!,
          _proteinEstimateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinEstimateMeta);
    }
    if (data.containsKey('feeling')) {
      context.handle(
        _feelingMeta,
        feeling.isAcceptableOrUnknown(data['feeling']!, _feelingMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('carb_estimate')) {
      context.handle(
        _carbEstimateMeta,
        carbEstimate.isAcceptableOrUnknown(
          data['carb_estimate']!,
          _carbEstimateMeta,
        ),
      );
    }
    if (data.containsKey('fat_estimate')) {
      context.handle(
        _fatEstimateMeta,
        fatEstimate.isAcceptableOrUnknown(
          data['fat_estimate']!,
          _fatEstimateMeta,
        ),
      );
    }
    if (data.containsKey('fiber_estimate')) {
      context.handle(
        _fiberEstimateMeta,
        fiberEstimate.isAcceptableOrUnknown(
          data['fiber_estimate']!,
          _fiberEstimateMeta,
        ),
      );
    }
    if (data.containsKey('calories_estimate')) {
      context.handle(
        _caloriesEstimateMeta,
        caloriesEstimate.isAcceptableOrUnknown(
          data['calories_estimate']!,
          _caloriesEstimateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealLog(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      mealTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}meal_time'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      proteinEstimate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}protein_estimate'],
          )!,
      feeling:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}feeling'],
          )!,
      notes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notes'],
          )!,
      carbEstimate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carb_estimate'],
      ),
      fatEstimate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_estimate'],
      ),
      fiberEstimate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_estimate'],
      ),
      caloriesEstimate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_estimate'],
      ),
    );
  }

  @override
  $MealLogsTable createAlias(String alias) {
    return $MealLogsTable(attachedDatabase, alias);
  }
}

class MealLog extends DataClass implements Insertable<MealLog> {
  final int id;
  final DateTime date;
  final DateTime mealTime;
  final String description;
  final String proteinEstimate;
  final String feeling;
  final String notes;
  final double? carbEstimate;
  final double? fatEstimate;
  final double? fiberEstimate;
  final double? caloriesEstimate;
  const MealLog({
    required this.id,
    required this.date,
    required this.mealTime,
    required this.description,
    required this.proteinEstimate,
    required this.feeling,
    required this.notes,
    this.carbEstimate,
    this.fatEstimate,
    this.fiberEstimate,
    this.caloriesEstimate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['meal_time'] = Variable<DateTime>(mealTime);
    map['description'] = Variable<String>(description);
    map['protein_estimate'] = Variable<String>(proteinEstimate);
    map['feeling'] = Variable<String>(feeling);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || carbEstimate != null) {
      map['carb_estimate'] = Variable<double>(carbEstimate);
    }
    if (!nullToAbsent || fatEstimate != null) {
      map['fat_estimate'] = Variable<double>(fatEstimate);
    }
    if (!nullToAbsent || fiberEstimate != null) {
      map['fiber_estimate'] = Variable<double>(fiberEstimate);
    }
    if (!nullToAbsent || caloriesEstimate != null) {
      map['calories_estimate'] = Variable<double>(caloriesEstimate);
    }
    return map;
  }

  MealLogsCompanion toCompanion(bool nullToAbsent) {
    return MealLogsCompanion(
      id: Value(id),
      date: Value(date),
      mealTime: Value(mealTime),
      description: Value(description),
      proteinEstimate: Value(proteinEstimate),
      feeling: Value(feeling),
      notes: Value(notes),
      carbEstimate:
          carbEstimate == null && nullToAbsent
              ? const Value.absent()
              : Value(carbEstimate),
      fatEstimate:
          fatEstimate == null && nullToAbsent
              ? const Value.absent()
              : Value(fatEstimate),
      fiberEstimate:
          fiberEstimate == null && nullToAbsent
              ? const Value.absent()
              : Value(fiberEstimate),
      caloriesEstimate:
          caloriesEstimate == null && nullToAbsent
              ? const Value.absent()
              : Value(caloriesEstimate),
    );
  }

  factory MealLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      mealTime: serializer.fromJson<DateTime>(json['mealTime']),
      description: serializer.fromJson<String>(json['description']),
      proteinEstimate: serializer.fromJson<String>(json['proteinEstimate']),
      feeling: serializer.fromJson<String>(json['feeling']),
      notes: serializer.fromJson<String>(json['notes']),
      carbEstimate: serializer.fromJson<double?>(json['carbEstimate']),
      fatEstimate: serializer.fromJson<double?>(json['fatEstimate']),
      fiberEstimate: serializer.fromJson<double?>(json['fiberEstimate']),
      caloriesEstimate: serializer.fromJson<double?>(json['caloriesEstimate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'mealTime': serializer.toJson<DateTime>(mealTime),
      'description': serializer.toJson<String>(description),
      'proteinEstimate': serializer.toJson<String>(proteinEstimate),
      'feeling': serializer.toJson<String>(feeling),
      'notes': serializer.toJson<String>(notes),
      'carbEstimate': serializer.toJson<double?>(carbEstimate),
      'fatEstimate': serializer.toJson<double?>(fatEstimate),
      'fiberEstimate': serializer.toJson<double?>(fiberEstimate),
      'caloriesEstimate': serializer.toJson<double?>(caloriesEstimate),
    };
  }

  MealLog copyWith({
    int? id,
    DateTime? date,
    DateTime? mealTime,
    String? description,
    String? proteinEstimate,
    String? feeling,
    String? notes,
    Value<double?> carbEstimate = const Value.absent(),
    Value<double?> fatEstimate = const Value.absent(),
    Value<double?> fiberEstimate = const Value.absent(),
    Value<double?> caloriesEstimate = const Value.absent(),
  }) => MealLog(
    id: id ?? this.id,
    date: date ?? this.date,
    mealTime: mealTime ?? this.mealTime,
    description: description ?? this.description,
    proteinEstimate: proteinEstimate ?? this.proteinEstimate,
    feeling: feeling ?? this.feeling,
    notes: notes ?? this.notes,
    carbEstimate: carbEstimate.present ? carbEstimate.value : this.carbEstimate,
    fatEstimate: fatEstimate.present ? fatEstimate.value : this.fatEstimate,
    fiberEstimate:
        fiberEstimate.present ? fiberEstimate.value : this.fiberEstimate,
    caloriesEstimate:
        caloriesEstimate.present
            ? caloriesEstimate.value
            : this.caloriesEstimate,
  );
  MealLog copyWithCompanion(MealLogsCompanion data) {
    return MealLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      mealTime: data.mealTime.present ? data.mealTime.value : this.mealTime,
      description:
          data.description.present ? data.description.value : this.description,
      proteinEstimate:
          data.proteinEstimate.present
              ? data.proteinEstimate.value
              : this.proteinEstimate,
      feeling: data.feeling.present ? data.feeling.value : this.feeling,
      notes: data.notes.present ? data.notes.value : this.notes,
      carbEstimate:
          data.carbEstimate.present
              ? data.carbEstimate.value
              : this.carbEstimate,
      fatEstimate:
          data.fatEstimate.present ? data.fatEstimate.value : this.fatEstimate,
      fiberEstimate:
          data.fiberEstimate.present
              ? data.fiberEstimate.value
              : this.fiberEstimate,
      caloriesEstimate:
          data.caloriesEstimate.present
              ? data.caloriesEstimate.value
              : this.caloriesEstimate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mealTime: $mealTime, ')
          ..write('description: $description, ')
          ..write('proteinEstimate: $proteinEstimate, ')
          ..write('feeling: $feeling, ')
          ..write('notes: $notes, ')
          ..write('carbEstimate: $carbEstimate, ')
          ..write('fatEstimate: $fatEstimate, ')
          ..write('fiberEstimate: $fiberEstimate, ')
          ..write('caloriesEstimate: $caloriesEstimate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    mealTime,
    description,
    proteinEstimate,
    feeling,
    notes,
    carbEstimate,
    fatEstimate,
    fiberEstimate,
    caloriesEstimate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.mealTime == this.mealTime &&
          other.description == this.description &&
          other.proteinEstimate == this.proteinEstimate &&
          other.feeling == this.feeling &&
          other.notes == this.notes &&
          other.carbEstimate == this.carbEstimate &&
          other.fatEstimate == this.fatEstimate &&
          other.fiberEstimate == this.fiberEstimate &&
          other.caloriesEstimate == this.caloriesEstimate);
}

class MealLogsCompanion extends UpdateCompanion<MealLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<DateTime> mealTime;
  final Value<String> description;
  final Value<String> proteinEstimate;
  final Value<String> feeling;
  final Value<String> notes;
  final Value<double?> carbEstimate;
  final Value<double?> fatEstimate;
  final Value<double?> fiberEstimate;
  final Value<double?> caloriesEstimate;
  const MealLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.mealTime = const Value.absent(),
    this.description = const Value.absent(),
    this.proteinEstimate = const Value.absent(),
    this.feeling = const Value.absent(),
    this.notes = const Value.absent(),
    this.carbEstimate = const Value.absent(),
    this.fatEstimate = const Value.absent(),
    this.fiberEstimate = const Value.absent(),
    this.caloriesEstimate = const Value.absent(),
  });
  MealLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required DateTime mealTime,
    required String description,
    required String proteinEstimate,
    this.feeling = const Value.absent(),
    this.notes = const Value.absent(),
    this.carbEstimate = const Value.absent(),
    this.fatEstimate = const Value.absent(),
    this.fiberEstimate = const Value.absent(),
    this.caloriesEstimate = const Value.absent(),
  }) : date = Value(date),
       mealTime = Value(mealTime),
       description = Value(description),
       proteinEstimate = Value(proteinEstimate);
  static Insertable<MealLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<DateTime>? mealTime,
    Expression<String>? description,
    Expression<String>? proteinEstimate,
    Expression<String>? feeling,
    Expression<String>? notes,
    Expression<double>? carbEstimate,
    Expression<double>? fatEstimate,
    Expression<double>? fiberEstimate,
    Expression<double>? caloriesEstimate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (mealTime != null) 'meal_time': mealTime,
      if (description != null) 'description': description,
      if (proteinEstimate != null) 'protein_estimate': proteinEstimate,
      if (feeling != null) 'feeling': feeling,
      if (notes != null) 'notes': notes,
      if (carbEstimate != null) 'carb_estimate': carbEstimate,
      if (fatEstimate != null) 'fat_estimate': fatEstimate,
      if (fiberEstimate != null) 'fiber_estimate': fiberEstimate,
      if (caloriesEstimate != null) 'calories_estimate': caloriesEstimate,
    });
  }

  MealLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<DateTime>? mealTime,
    Value<String>? description,
    Value<String>? proteinEstimate,
    Value<String>? feeling,
    Value<String>? notes,
    Value<double?>? carbEstimate,
    Value<double?>? fatEstimate,
    Value<double?>? fiberEstimate,
    Value<double?>? caloriesEstimate,
  }) {
    return MealLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      mealTime: mealTime ?? this.mealTime,
      description: description ?? this.description,
      proteinEstimate: proteinEstimate ?? this.proteinEstimate,
      feeling: feeling ?? this.feeling,
      notes: notes ?? this.notes,
      carbEstimate: carbEstimate ?? this.carbEstimate,
      fatEstimate: fatEstimate ?? this.fatEstimate,
      fiberEstimate: fiberEstimate ?? this.fiberEstimate,
      caloriesEstimate: caloriesEstimate ?? this.caloriesEstimate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (mealTime.present) {
      map['meal_time'] = Variable<DateTime>(mealTime.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (proteinEstimate.present) {
      map['protein_estimate'] = Variable<String>(proteinEstimate.value);
    }
    if (feeling.present) {
      map['feeling'] = Variable<String>(feeling.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (carbEstimate.present) {
      map['carb_estimate'] = Variable<double>(carbEstimate.value);
    }
    if (fatEstimate.present) {
      map['fat_estimate'] = Variable<double>(fatEstimate.value);
    }
    if (fiberEstimate.present) {
      map['fiber_estimate'] = Variable<double>(fiberEstimate.value);
    }
    if (caloriesEstimate.present) {
      map['calories_estimate'] = Variable<double>(caloriesEstimate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mealTime: $mealTime, ')
          ..write('description: $description, ')
          ..write('proteinEstimate: $proteinEstimate, ')
          ..write('feeling: $feeling, ')
          ..write('notes: $notes, ')
          ..write('carbEstimate: $carbEstimate, ')
          ..write('fatEstimate: $fatEstimate, ')
          ..write('fiberEstimate: $fiberEstimate, ')
          ..write('caloriesEstimate: $caloriesEstimate')
          ..write(')'))
        .toString();
  }
}

class $FoodItemsTable extends FoodItems
    with TableInfo<$FoodItemsTable, FoodItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinPer100gMeta = const VerificationMeta(
    'proteinPer100g',
  );
  @override
  late final GeneratedColumn<double> proteinPer100g = GeneratedColumn<double>(
    'protein_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsPer100gMeta = const VerificationMeta(
    'carbsPer100g',
  );
  @override
  late final GeneratedColumn<double> carbsPer100g = GeneratedColumn<double>(
    'carbs_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatsPer100gMeta = const VerificationMeta(
    'fatsPer100g',
  );
  @override
  late final GeneratedColumn<double> fatsPer100g = GeneratedColumn<double>(
    'fats_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesPer100gMeta = const VerificationMeta(
    'caloriesPer100g',
  );
  @override
  late final GeneratedColumn<double> caloriesPer100g = GeneratedColumn<double>(
    'calories_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberPer100gMeta = const VerificationMeta(
    'fiberPer100g',
  );
  @override
  late final GeneratedColumn<double> fiberPer100g = GeneratedColumn<double>(
    'fiber_per100g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _glycemicIndexMeta = const VerificationMeta(
    'glycemicIndex',
  );
  @override
  late final GeneratedColumn<int> glycemicIndex = GeneratedColumn<int>(
    'glycemic_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _portionExampleMeta = const VerificationMeta(
    'portionExample',
  );
  @override
  late final GeneratedColumn<String> portionExample = GeneratedColumn<String>(
    'portion_example',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _useIdeasMeta = const VerificationMeta(
    'useIdeas',
  );
  @override
  late final GeneratedColumn<String> useIdeas = GeneratedColumn<String>(
    'use_ideas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longevityBenefitMeta = const VerificationMeta(
    'longevityBenefit',
  );
  @override
  late final GeneratedColumn<String> longevityBenefit = GeneratedColumn<String>(
    'longevity_benefit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeCompoundsMeta = const VerificationMeta(
    'activeCompounds',
  );
  @override
  late final GeneratedColumn<String> activeCompounds = GeneratedColumn<String>(
    'active_compounds',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longevityTierMeta = const VerificationMeta(
    'longevityTier',
  );
  @override
  late final GeneratedColumn<int> longevityTier = GeneratedColumn<int>(
    'longevity_tier',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idealTimingMeta = const VerificationMeta(
    'idealTiming',
  );
  @override
  late final GeneratedColumn<String> idealTiming = GeneratedColumn<String>(
    'ideal_timing',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    proteinPer100g,
    carbsPer100g,
    fatsPer100g,
    caloriesPer100g,
    fiberPer100g,
    glycemicIndex,
    portionExample,
    useIdeas,
    longevityBenefit,
    activeCompounds,
    longevityTier,
    idealTiming,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('protein_per100g')) {
      context.handle(
        _proteinPer100gMeta,
        proteinPer100g.isAcceptableOrUnknown(
          data['protein_per100g']!,
          _proteinPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinPer100gMeta);
    }
    if (data.containsKey('carbs_per100g')) {
      context.handle(
        _carbsPer100gMeta,
        carbsPer100g.isAcceptableOrUnknown(
          data['carbs_per100g']!,
          _carbsPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbsPer100gMeta);
    }
    if (data.containsKey('fats_per100g')) {
      context.handle(
        _fatsPer100gMeta,
        fatsPer100g.isAcceptableOrUnknown(
          data['fats_per100g']!,
          _fatsPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fatsPer100gMeta);
    }
    if (data.containsKey('calories_per100g')) {
      context.handle(
        _caloriesPer100gMeta,
        caloriesPer100g.isAcceptableOrUnknown(
          data['calories_per100g']!,
          _caloriesPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesPer100gMeta);
    }
    if (data.containsKey('fiber_per100g')) {
      context.handle(
        _fiberPer100gMeta,
        fiberPer100g.isAcceptableOrUnknown(
          data['fiber_per100g']!,
          _fiberPer100gMeta,
        ),
      );
    }
    if (data.containsKey('glycemic_index')) {
      context.handle(
        _glycemicIndexMeta,
        glycemicIndex.isAcceptableOrUnknown(
          data['glycemic_index']!,
          _glycemicIndexMeta,
        ),
      );
    }
    if (data.containsKey('portion_example')) {
      context.handle(
        _portionExampleMeta,
        portionExample.isAcceptableOrUnknown(
          data['portion_example']!,
          _portionExampleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_portionExampleMeta);
    }
    if (data.containsKey('use_ideas')) {
      context.handle(
        _useIdeasMeta,
        useIdeas.isAcceptableOrUnknown(data['use_ideas']!, _useIdeasMeta),
      );
    } else if (isInserting) {
      context.missing(_useIdeasMeta);
    }
    if (data.containsKey('longevity_benefit')) {
      context.handle(
        _longevityBenefitMeta,
        longevityBenefit.isAcceptableOrUnknown(
          data['longevity_benefit']!,
          _longevityBenefitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_longevityBenefitMeta);
    }
    if (data.containsKey('active_compounds')) {
      context.handle(
        _activeCompoundsMeta,
        activeCompounds.isAcceptableOrUnknown(
          data['active_compounds']!,
          _activeCompoundsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeCompoundsMeta);
    }
    if (data.containsKey('longevity_tier')) {
      context.handle(
        _longevityTierMeta,
        longevityTier.isAcceptableOrUnknown(
          data['longevity_tier']!,
          _longevityTierMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_longevityTierMeta);
    }
    if (data.containsKey('ideal_timing')) {
      context.handle(
        _idealTimingMeta,
        idealTiming.isAcceptableOrUnknown(
          data['ideal_timing']!,
          _idealTimingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodItem(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      category:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}category'],
          )!,
      proteinPer100g:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}protein_per100g'],
          )!,
      carbsPer100g:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}carbs_per100g'],
          )!,
      fatsPer100g:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}fats_per100g'],
          )!,
      caloriesPer100g:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}calories_per100g'],
          )!,
      fiberPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_per100g'],
      ),
      glycemicIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}glycemic_index'],
      ),
      portionExample:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}portion_example'],
          )!,
      useIdeas:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}use_ideas'],
          )!,
      longevityBenefit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}longevity_benefit'],
          )!,
      activeCompounds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}active_compounds'],
          )!,
      longevityTier:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}longevity_tier'],
          )!,
      idealTiming: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ideal_timing'],
      ),
    );
  }

  @override
  $FoodItemsTable createAlias(String alias) {
    return $FoodItemsTable(attachedDatabase, alias);
  }
}

class FoodItem extends DataClass implements Insertable<FoodItem> {
  final int id;
  final String name;
  final String category;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatsPer100g;
  final double caloriesPer100g;
  final double? fiberPer100g;
  final int? glycemicIndex;
  final String portionExample;
  final String useIdeas;
  final String longevityBenefit;
  final String activeCompounds;
  final int longevityTier;
  final String? idealTiming;
  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatsPer100g,
    required this.caloriesPer100g,
    this.fiberPer100g,
    this.glycemicIndex,
    required this.portionExample,
    required this.useIdeas,
    required this.longevityBenefit,
    required this.activeCompounds,
    required this.longevityTier,
    this.idealTiming,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['protein_per100g'] = Variable<double>(proteinPer100g);
    map['carbs_per100g'] = Variable<double>(carbsPer100g);
    map['fats_per100g'] = Variable<double>(fatsPer100g);
    map['calories_per100g'] = Variable<double>(caloriesPer100g);
    if (!nullToAbsent || fiberPer100g != null) {
      map['fiber_per100g'] = Variable<double>(fiberPer100g);
    }
    if (!nullToAbsent || glycemicIndex != null) {
      map['glycemic_index'] = Variable<int>(glycemicIndex);
    }
    map['portion_example'] = Variable<String>(portionExample);
    map['use_ideas'] = Variable<String>(useIdeas);
    map['longevity_benefit'] = Variable<String>(longevityBenefit);
    map['active_compounds'] = Variable<String>(activeCompounds);
    map['longevity_tier'] = Variable<int>(longevityTier);
    if (!nullToAbsent || idealTiming != null) {
      map['ideal_timing'] = Variable<String>(idealTiming);
    }
    return map;
  }

  FoodItemsCompanion toCompanion(bool nullToAbsent) {
    return FoodItemsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      proteinPer100g: Value(proteinPer100g),
      carbsPer100g: Value(carbsPer100g),
      fatsPer100g: Value(fatsPer100g),
      caloriesPer100g: Value(caloriesPer100g),
      fiberPer100g:
          fiberPer100g == null && nullToAbsent
              ? const Value.absent()
              : Value(fiberPer100g),
      glycemicIndex:
          glycemicIndex == null && nullToAbsent
              ? const Value.absent()
              : Value(glycemicIndex),
      portionExample: Value(portionExample),
      useIdeas: Value(useIdeas),
      longevityBenefit: Value(longevityBenefit),
      activeCompounds: Value(activeCompounds),
      longevityTier: Value(longevityTier),
      idealTiming:
          idealTiming == null && nullToAbsent
              ? const Value.absent()
              : Value(idealTiming),
    );
  }

  factory FoodItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      proteinPer100g: serializer.fromJson<double>(json['proteinPer100g']),
      carbsPer100g: serializer.fromJson<double>(json['carbsPer100g']),
      fatsPer100g: serializer.fromJson<double>(json['fatsPer100g']),
      caloriesPer100g: serializer.fromJson<double>(json['caloriesPer100g']),
      fiberPer100g: serializer.fromJson<double?>(json['fiberPer100g']),
      glycemicIndex: serializer.fromJson<int?>(json['glycemicIndex']),
      portionExample: serializer.fromJson<String>(json['portionExample']),
      useIdeas: serializer.fromJson<String>(json['useIdeas']),
      longevityBenefit: serializer.fromJson<String>(json['longevityBenefit']),
      activeCompounds: serializer.fromJson<String>(json['activeCompounds']),
      longevityTier: serializer.fromJson<int>(json['longevityTier']),
      idealTiming: serializer.fromJson<String?>(json['idealTiming']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'proteinPer100g': serializer.toJson<double>(proteinPer100g),
      'carbsPer100g': serializer.toJson<double>(carbsPer100g),
      'fatsPer100g': serializer.toJson<double>(fatsPer100g),
      'caloriesPer100g': serializer.toJson<double>(caloriesPer100g),
      'fiberPer100g': serializer.toJson<double?>(fiberPer100g),
      'glycemicIndex': serializer.toJson<int?>(glycemicIndex),
      'portionExample': serializer.toJson<String>(portionExample),
      'useIdeas': serializer.toJson<String>(useIdeas),
      'longevityBenefit': serializer.toJson<String>(longevityBenefit),
      'activeCompounds': serializer.toJson<String>(activeCompounds),
      'longevityTier': serializer.toJson<int>(longevityTier),
      'idealTiming': serializer.toJson<String?>(idealTiming),
    };
  }

  FoodItem copyWith({
    int? id,
    String? name,
    String? category,
    double? proteinPer100g,
    double? carbsPer100g,
    double? fatsPer100g,
    double? caloriesPer100g,
    Value<double?> fiberPer100g = const Value.absent(),
    Value<int?> glycemicIndex = const Value.absent(),
    String? portionExample,
    String? useIdeas,
    String? longevityBenefit,
    String? activeCompounds,
    int? longevityTier,
    Value<String?> idealTiming = const Value.absent(),
  }) => FoodItem(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    proteinPer100g: proteinPer100g ?? this.proteinPer100g,
    carbsPer100g: carbsPer100g ?? this.carbsPer100g,
    fatsPer100g: fatsPer100g ?? this.fatsPer100g,
    caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
    fiberPer100g: fiberPer100g.present ? fiberPer100g.value : this.fiberPer100g,
    glycemicIndex:
        glycemicIndex.present ? glycemicIndex.value : this.glycemicIndex,
    portionExample: portionExample ?? this.portionExample,
    useIdeas: useIdeas ?? this.useIdeas,
    longevityBenefit: longevityBenefit ?? this.longevityBenefit,
    activeCompounds: activeCompounds ?? this.activeCompounds,
    longevityTier: longevityTier ?? this.longevityTier,
    idealTiming: idealTiming.present ? idealTiming.value : this.idealTiming,
  );
  FoodItem copyWithCompanion(FoodItemsCompanion data) {
    return FoodItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      proteinPer100g:
          data.proteinPer100g.present
              ? data.proteinPer100g.value
              : this.proteinPer100g,
      carbsPer100g:
          data.carbsPer100g.present
              ? data.carbsPer100g.value
              : this.carbsPer100g,
      fatsPer100g:
          data.fatsPer100g.present ? data.fatsPer100g.value : this.fatsPer100g,
      caloriesPer100g:
          data.caloriesPer100g.present
              ? data.caloriesPer100g.value
              : this.caloriesPer100g,
      fiberPer100g:
          data.fiberPer100g.present
              ? data.fiberPer100g.value
              : this.fiberPer100g,
      glycemicIndex:
          data.glycemicIndex.present
              ? data.glycemicIndex.value
              : this.glycemicIndex,
      portionExample:
          data.portionExample.present
              ? data.portionExample.value
              : this.portionExample,
      useIdeas: data.useIdeas.present ? data.useIdeas.value : this.useIdeas,
      longevityBenefit:
          data.longevityBenefit.present
              ? data.longevityBenefit.value
              : this.longevityBenefit,
      activeCompounds:
          data.activeCompounds.present
              ? data.activeCompounds.value
              : this.activeCompounds,
      longevityTier:
          data.longevityTier.present
              ? data.longevityTier.value
              : this.longevityTier,
      idealTiming:
          data.idealTiming.present ? data.idealTiming.value : this.idealTiming,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fatsPer100g: $fatsPer100g, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('fiberPer100g: $fiberPer100g, ')
          ..write('glycemicIndex: $glycemicIndex, ')
          ..write('portionExample: $portionExample, ')
          ..write('useIdeas: $useIdeas, ')
          ..write('longevityBenefit: $longevityBenefit, ')
          ..write('activeCompounds: $activeCompounds, ')
          ..write('longevityTier: $longevityTier, ')
          ..write('idealTiming: $idealTiming')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    proteinPer100g,
    carbsPer100g,
    fatsPer100g,
    caloriesPer100g,
    fiberPer100g,
    glycemicIndex,
    portionExample,
    useIdeas,
    longevityBenefit,
    activeCompounds,
    longevityTier,
    idealTiming,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.proteinPer100g == this.proteinPer100g &&
          other.carbsPer100g == this.carbsPer100g &&
          other.fatsPer100g == this.fatsPer100g &&
          other.caloriesPer100g == this.caloriesPer100g &&
          other.fiberPer100g == this.fiberPer100g &&
          other.glycemicIndex == this.glycemicIndex &&
          other.portionExample == this.portionExample &&
          other.useIdeas == this.useIdeas &&
          other.longevityBenefit == this.longevityBenefit &&
          other.activeCompounds == this.activeCompounds &&
          other.longevityTier == this.longevityTier &&
          other.idealTiming == this.idealTiming);
}

class FoodItemsCompanion extends UpdateCompanion<FoodItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<double> proteinPer100g;
  final Value<double> carbsPer100g;
  final Value<double> fatsPer100g;
  final Value<double> caloriesPer100g;
  final Value<double?> fiberPer100g;
  final Value<int?> glycemicIndex;
  final Value<String> portionExample;
  final Value<String> useIdeas;
  final Value<String> longevityBenefit;
  final Value<String> activeCompounds;
  final Value<int> longevityTier;
  final Value<String?> idealTiming;
  const FoodItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.proteinPer100g = const Value.absent(),
    this.carbsPer100g = const Value.absent(),
    this.fatsPer100g = const Value.absent(),
    this.caloriesPer100g = const Value.absent(),
    this.fiberPer100g = const Value.absent(),
    this.glycemicIndex = const Value.absent(),
    this.portionExample = const Value.absent(),
    this.useIdeas = const Value.absent(),
    this.longevityBenefit = const Value.absent(),
    this.activeCompounds = const Value.absent(),
    this.longevityTier = const Value.absent(),
    this.idealTiming = const Value.absent(),
  });
  FoodItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    required double proteinPer100g,
    required double carbsPer100g,
    required double fatsPer100g,
    required double caloriesPer100g,
    this.fiberPer100g = const Value.absent(),
    this.glycemicIndex = const Value.absent(),
    required String portionExample,
    required String useIdeas,
    required String longevityBenefit,
    required String activeCompounds,
    required int longevityTier,
    this.idealTiming = const Value.absent(),
  }) : name = Value(name),
       category = Value(category),
       proteinPer100g = Value(proteinPer100g),
       carbsPer100g = Value(carbsPer100g),
       fatsPer100g = Value(fatsPer100g),
       caloriesPer100g = Value(caloriesPer100g),
       portionExample = Value(portionExample),
       useIdeas = Value(useIdeas),
       longevityBenefit = Value(longevityBenefit),
       activeCompounds = Value(activeCompounds),
       longevityTier = Value(longevityTier);
  static Insertable<FoodItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? proteinPer100g,
    Expression<double>? carbsPer100g,
    Expression<double>? fatsPer100g,
    Expression<double>? caloriesPer100g,
    Expression<double>? fiberPer100g,
    Expression<int>? glycemicIndex,
    Expression<String>? portionExample,
    Expression<String>? useIdeas,
    Expression<String>? longevityBenefit,
    Expression<String>? activeCompounds,
    Expression<int>? longevityTier,
    Expression<String>? idealTiming,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (proteinPer100g != null) 'protein_per100g': proteinPer100g,
      if (carbsPer100g != null) 'carbs_per100g': carbsPer100g,
      if (fatsPer100g != null) 'fats_per100g': fatsPer100g,
      if (caloriesPer100g != null) 'calories_per100g': caloriesPer100g,
      if (fiberPer100g != null) 'fiber_per100g': fiberPer100g,
      if (glycemicIndex != null) 'glycemic_index': glycemicIndex,
      if (portionExample != null) 'portion_example': portionExample,
      if (useIdeas != null) 'use_ideas': useIdeas,
      if (longevityBenefit != null) 'longevity_benefit': longevityBenefit,
      if (activeCompounds != null) 'active_compounds': activeCompounds,
      if (longevityTier != null) 'longevity_tier': longevityTier,
      if (idealTiming != null) 'ideal_timing': idealTiming,
    });
  }

  FoodItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? category,
    Value<double>? proteinPer100g,
    Value<double>? carbsPer100g,
    Value<double>? fatsPer100g,
    Value<double>? caloriesPer100g,
    Value<double?>? fiberPer100g,
    Value<int?>? glycemicIndex,
    Value<String>? portionExample,
    Value<String>? useIdeas,
    Value<String>? longevityBenefit,
    Value<String>? activeCompounds,
    Value<int>? longevityTier,
    Value<String?>? idealTiming,
  }) {
    return FoodItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      proteinPer100g: proteinPer100g ?? this.proteinPer100g,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      fatsPer100g: fatsPer100g ?? this.fatsPer100g,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      fiberPer100g: fiberPer100g ?? this.fiberPer100g,
      glycemicIndex: glycemicIndex ?? this.glycemicIndex,
      portionExample: portionExample ?? this.portionExample,
      useIdeas: useIdeas ?? this.useIdeas,
      longevityBenefit: longevityBenefit ?? this.longevityBenefit,
      activeCompounds: activeCompounds ?? this.activeCompounds,
      longevityTier: longevityTier ?? this.longevityTier,
      idealTiming: idealTiming ?? this.idealTiming,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (proteinPer100g.present) {
      map['protein_per100g'] = Variable<double>(proteinPer100g.value);
    }
    if (carbsPer100g.present) {
      map['carbs_per100g'] = Variable<double>(carbsPer100g.value);
    }
    if (fatsPer100g.present) {
      map['fats_per100g'] = Variable<double>(fatsPer100g.value);
    }
    if (caloriesPer100g.present) {
      map['calories_per100g'] = Variable<double>(caloriesPer100g.value);
    }
    if (fiberPer100g.present) {
      map['fiber_per100g'] = Variable<double>(fiberPer100g.value);
    }
    if (glycemicIndex.present) {
      map['glycemic_index'] = Variable<int>(glycemicIndex.value);
    }
    if (portionExample.present) {
      map['portion_example'] = Variable<String>(portionExample.value);
    }
    if (useIdeas.present) {
      map['use_ideas'] = Variable<String>(useIdeas.value);
    }
    if (longevityBenefit.present) {
      map['longevity_benefit'] = Variable<String>(longevityBenefit.value);
    }
    if (activeCompounds.present) {
      map['active_compounds'] = Variable<String>(activeCompounds.value);
    }
    if (longevityTier.present) {
      map['longevity_tier'] = Variable<int>(longevityTier.value);
    }
    if (idealTiming.present) {
      map['ideal_timing'] = Variable<String>(idealTiming.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fatsPer100g: $fatsPer100g, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('fiberPer100g: $fiberPer100g, ')
          ..write('glycemicIndex: $glycemicIndex, ')
          ..write('portionExample: $portionExample, ')
          ..write('useIdeas: $useIdeas, ')
          ..write('longevityBenefit: $longevityBenefit, ')
          ..write('activeCompounds: $activeCompounds, ')
          ..write('longevityTier: $longevityTier, ')
          ..write('idealTiming: $idealTiming')
          ..write(')'))
        .toString();
  }
}

class $MealTemplatesTable extends MealTemplates
    with TableInfo<$MealTemplatesTable, MealTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayTypeMeta = const VerificationMeta(
    'dayType',
  );
  @override
  late final GeneratedColumn<String> dayType = GeneratedColumn<String>(
    'day_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealNumberMeta = const VerificationMeta(
    'mealNumber',
  );
  @override
  late final GeneratedColumn<int> mealNumber = GeneratedColumn<int>(
    'meal_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeSlotMeta = const VerificationMeta(
    'timeSlot',
  );
  @override
  late final GeneratedColumn<String> timeSlot = GeneratedColumn<String>(
    'time_slot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientsMeta = const VerificationMeta(
    'ingredients',
  );
  @override
  late final GeneratedColumn<String> ingredients = GeneratedColumn<String>(
    'ingredients',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinEstimateGMeta = const VerificationMeta(
    'proteinEstimateG',
  );
  @override
  late final GeneratedColumn<double> proteinEstimateG = GeneratedColumn<double>(
    'protein_estimate_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesEstimateMeta = const VerificationMeta(
    'caloriesEstimate',
  );
  @override
  late final GeneratedColumn<double> caloriesEstimate = GeneratedColumn<double>(
    'calories_estimate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cookingMethodMeta = const VerificationMeta(
    'cookingMethod',
  );
  @override
  late final GeneratedColumn<String> cookingMethod = GeneratedColumn<String>(
    'cooking_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timingMeta = const VerificationMeta('timing');
  @override
  late final GeneratedColumn<String> timing = GeneratedColumn<String>(
    'timing',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbEstimateGMeta = const VerificationMeta(
    'carbEstimateG',
  );
  @override
  late final GeneratedColumn<double> carbEstimateG = GeneratedColumn<double>(
    'carb_estimate_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatEstimateGMeta = const VerificationMeta(
    'fatEstimateG',
  );
  @override
  late final GeneratedColumn<double> fatEstimateG = GeneratedColumn<double>(
    'fat_estimate_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fiberEstimateGMeta = const VerificationMeta(
    'fiberEstimateG',
  );
  @override
  late final GeneratedColumn<double> fiberEstimateG = GeneratedColumn<double>(
    'fiber_estimate_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayType,
    mealNumber,
    timeSlot,
    description,
    ingredients,
    proteinEstimateG,
    caloriesEstimate,
    cookingMethod,
    timing,
    carbEstimateG,
    fatEstimateG,
    fiberEstimateG,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_type')) {
      context.handle(
        _dayTypeMeta,
        dayType.isAcceptableOrUnknown(data['day_type']!, _dayTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_dayTypeMeta);
    }
    if (data.containsKey('meal_number')) {
      context.handle(
        _mealNumberMeta,
        mealNumber.isAcceptableOrUnknown(data['meal_number']!, _mealNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_mealNumberMeta);
    }
    if (data.containsKey('time_slot')) {
      context.handle(
        _timeSlotMeta,
        timeSlot.isAcceptableOrUnknown(data['time_slot']!, _timeSlotMeta),
      );
    } else if (isInserting) {
      context.missing(_timeSlotMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('ingredients')) {
      context.handle(
        _ingredientsMeta,
        ingredients.isAcceptableOrUnknown(
          data['ingredients']!,
          _ingredientsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientsMeta);
    }
    if (data.containsKey('protein_estimate_g')) {
      context.handle(
        _proteinEstimateGMeta,
        proteinEstimateG.isAcceptableOrUnknown(
          data['protein_estimate_g']!,
          _proteinEstimateGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinEstimateGMeta);
    }
    if (data.containsKey('calories_estimate')) {
      context.handle(
        _caloriesEstimateMeta,
        caloriesEstimate.isAcceptableOrUnknown(
          data['calories_estimate']!,
          _caloriesEstimateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesEstimateMeta);
    }
    if (data.containsKey('cooking_method')) {
      context.handle(
        _cookingMethodMeta,
        cookingMethod.isAcceptableOrUnknown(
          data['cooking_method']!,
          _cookingMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cookingMethodMeta);
    }
    if (data.containsKey('timing')) {
      context.handle(
        _timingMeta,
        timing.isAcceptableOrUnknown(data['timing']!, _timingMeta),
      );
    } else if (isInserting) {
      context.missing(_timingMeta);
    }
    if (data.containsKey('carb_estimate_g')) {
      context.handle(
        _carbEstimateGMeta,
        carbEstimateG.isAcceptableOrUnknown(
          data['carb_estimate_g']!,
          _carbEstimateGMeta,
        ),
      );
    }
    if (data.containsKey('fat_estimate_g')) {
      context.handle(
        _fatEstimateGMeta,
        fatEstimateG.isAcceptableOrUnknown(
          data['fat_estimate_g']!,
          _fatEstimateGMeta,
        ),
      );
    }
    if (data.containsKey('fiber_estimate_g')) {
      context.handle(
        _fiberEstimateGMeta,
        fiberEstimateG.isAcceptableOrUnknown(
          data['fiber_estimate_g']!,
          _fiberEstimateGMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealTemplate(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      dayType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}day_type'],
          )!,
      mealNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}meal_number'],
          )!,
      timeSlot:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}time_slot'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      ingredients:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}ingredients'],
          )!,
      proteinEstimateG:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}protein_estimate_g'],
          )!,
      caloriesEstimate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}calories_estimate'],
          )!,
      cookingMethod:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}cooking_method'],
          )!,
      timing:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}timing'],
          )!,
      carbEstimateG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carb_estimate_g'],
      ),
      fatEstimateG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_estimate_g'],
      ),
      fiberEstimateG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_estimate_g'],
      ),
    );
  }

  @override
  $MealTemplatesTable createAlias(String alias) {
    return $MealTemplatesTable(attachedDatabase, alias);
  }
}

class MealTemplate extends DataClass implements Insertable<MealTemplate> {
  final int id;
  final String dayType;
  final int mealNumber;
  final String timeSlot;
  final String description;
  final String ingredients;
  final double proteinEstimateG;
  final double caloriesEstimate;
  final String cookingMethod;
  final String timing;
  final double? carbEstimateG;
  final double? fatEstimateG;
  final double? fiberEstimateG;
  const MealTemplate({
    required this.id,
    required this.dayType,
    required this.mealNumber,
    required this.timeSlot,
    required this.description,
    required this.ingredients,
    required this.proteinEstimateG,
    required this.caloriesEstimate,
    required this.cookingMethod,
    required this.timing,
    this.carbEstimateG,
    this.fatEstimateG,
    this.fiberEstimateG,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_type'] = Variable<String>(dayType);
    map['meal_number'] = Variable<int>(mealNumber);
    map['time_slot'] = Variable<String>(timeSlot);
    map['description'] = Variable<String>(description);
    map['ingredients'] = Variable<String>(ingredients);
    map['protein_estimate_g'] = Variable<double>(proteinEstimateG);
    map['calories_estimate'] = Variable<double>(caloriesEstimate);
    map['cooking_method'] = Variable<String>(cookingMethod);
    map['timing'] = Variable<String>(timing);
    if (!nullToAbsent || carbEstimateG != null) {
      map['carb_estimate_g'] = Variable<double>(carbEstimateG);
    }
    if (!nullToAbsent || fatEstimateG != null) {
      map['fat_estimate_g'] = Variable<double>(fatEstimateG);
    }
    if (!nullToAbsent || fiberEstimateG != null) {
      map['fiber_estimate_g'] = Variable<double>(fiberEstimateG);
    }
    return map;
  }

  MealTemplatesCompanion toCompanion(bool nullToAbsent) {
    return MealTemplatesCompanion(
      id: Value(id),
      dayType: Value(dayType),
      mealNumber: Value(mealNumber),
      timeSlot: Value(timeSlot),
      description: Value(description),
      ingredients: Value(ingredients),
      proteinEstimateG: Value(proteinEstimateG),
      caloriesEstimate: Value(caloriesEstimate),
      cookingMethod: Value(cookingMethod),
      timing: Value(timing),
      carbEstimateG:
          carbEstimateG == null && nullToAbsent
              ? const Value.absent()
              : Value(carbEstimateG),
      fatEstimateG:
          fatEstimateG == null && nullToAbsent
              ? const Value.absent()
              : Value(fatEstimateG),
      fiberEstimateG:
          fiberEstimateG == null && nullToAbsent
              ? const Value.absent()
              : Value(fiberEstimateG),
    );
  }

  factory MealTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealTemplate(
      id: serializer.fromJson<int>(json['id']),
      dayType: serializer.fromJson<String>(json['dayType']),
      mealNumber: serializer.fromJson<int>(json['mealNumber']),
      timeSlot: serializer.fromJson<String>(json['timeSlot']),
      description: serializer.fromJson<String>(json['description']),
      ingredients: serializer.fromJson<String>(json['ingredients']),
      proteinEstimateG: serializer.fromJson<double>(json['proteinEstimateG']),
      caloriesEstimate: serializer.fromJson<double>(json['caloriesEstimate']),
      cookingMethod: serializer.fromJson<String>(json['cookingMethod']),
      timing: serializer.fromJson<String>(json['timing']),
      carbEstimateG: serializer.fromJson<double?>(json['carbEstimateG']),
      fatEstimateG: serializer.fromJson<double?>(json['fatEstimateG']),
      fiberEstimateG: serializer.fromJson<double?>(json['fiberEstimateG']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayType': serializer.toJson<String>(dayType),
      'mealNumber': serializer.toJson<int>(mealNumber),
      'timeSlot': serializer.toJson<String>(timeSlot),
      'description': serializer.toJson<String>(description),
      'ingredients': serializer.toJson<String>(ingredients),
      'proteinEstimateG': serializer.toJson<double>(proteinEstimateG),
      'caloriesEstimate': serializer.toJson<double>(caloriesEstimate),
      'cookingMethod': serializer.toJson<String>(cookingMethod),
      'timing': serializer.toJson<String>(timing),
      'carbEstimateG': serializer.toJson<double?>(carbEstimateG),
      'fatEstimateG': serializer.toJson<double?>(fatEstimateG),
      'fiberEstimateG': serializer.toJson<double?>(fiberEstimateG),
    };
  }

  MealTemplate copyWith({
    int? id,
    String? dayType,
    int? mealNumber,
    String? timeSlot,
    String? description,
    String? ingredients,
    double? proteinEstimateG,
    double? caloriesEstimate,
    String? cookingMethod,
    String? timing,
    Value<double?> carbEstimateG = const Value.absent(),
    Value<double?> fatEstimateG = const Value.absent(),
    Value<double?> fiberEstimateG = const Value.absent(),
  }) => MealTemplate(
    id: id ?? this.id,
    dayType: dayType ?? this.dayType,
    mealNumber: mealNumber ?? this.mealNumber,
    timeSlot: timeSlot ?? this.timeSlot,
    description: description ?? this.description,
    ingredients: ingredients ?? this.ingredients,
    proteinEstimateG: proteinEstimateG ?? this.proteinEstimateG,
    caloriesEstimate: caloriesEstimate ?? this.caloriesEstimate,
    cookingMethod: cookingMethod ?? this.cookingMethod,
    timing: timing ?? this.timing,
    carbEstimateG:
        carbEstimateG.present ? carbEstimateG.value : this.carbEstimateG,
    fatEstimateG: fatEstimateG.present ? fatEstimateG.value : this.fatEstimateG,
    fiberEstimateG:
        fiberEstimateG.present ? fiberEstimateG.value : this.fiberEstimateG,
  );
  MealTemplate copyWithCompanion(MealTemplatesCompanion data) {
    return MealTemplate(
      id: data.id.present ? data.id.value : this.id,
      dayType: data.dayType.present ? data.dayType.value : this.dayType,
      mealNumber:
          data.mealNumber.present ? data.mealNumber.value : this.mealNumber,
      timeSlot: data.timeSlot.present ? data.timeSlot.value : this.timeSlot,
      description:
          data.description.present ? data.description.value : this.description,
      ingredients:
          data.ingredients.present ? data.ingredients.value : this.ingredients,
      proteinEstimateG:
          data.proteinEstimateG.present
              ? data.proteinEstimateG.value
              : this.proteinEstimateG,
      caloriesEstimate:
          data.caloriesEstimate.present
              ? data.caloriesEstimate.value
              : this.caloriesEstimate,
      cookingMethod:
          data.cookingMethod.present
              ? data.cookingMethod.value
              : this.cookingMethod,
      timing: data.timing.present ? data.timing.value : this.timing,
      carbEstimateG:
          data.carbEstimateG.present
              ? data.carbEstimateG.value
              : this.carbEstimateG,
      fatEstimateG:
          data.fatEstimateG.present
              ? data.fatEstimateG.value
              : this.fatEstimateG,
      fiberEstimateG:
          data.fiberEstimateG.present
              ? data.fiberEstimateG.value
              : this.fiberEstimateG,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealTemplate(')
          ..write('id: $id, ')
          ..write('dayType: $dayType, ')
          ..write('mealNumber: $mealNumber, ')
          ..write('timeSlot: $timeSlot, ')
          ..write('description: $description, ')
          ..write('ingredients: $ingredients, ')
          ..write('proteinEstimateG: $proteinEstimateG, ')
          ..write('caloriesEstimate: $caloriesEstimate, ')
          ..write('cookingMethod: $cookingMethod, ')
          ..write('timing: $timing, ')
          ..write('carbEstimateG: $carbEstimateG, ')
          ..write('fatEstimateG: $fatEstimateG, ')
          ..write('fiberEstimateG: $fiberEstimateG')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayType,
    mealNumber,
    timeSlot,
    description,
    ingredients,
    proteinEstimateG,
    caloriesEstimate,
    cookingMethod,
    timing,
    carbEstimateG,
    fatEstimateG,
    fiberEstimateG,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealTemplate &&
          other.id == this.id &&
          other.dayType == this.dayType &&
          other.mealNumber == this.mealNumber &&
          other.timeSlot == this.timeSlot &&
          other.description == this.description &&
          other.ingredients == this.ingredients &&
          other.proteinEstimateG == this.proteinEstimateG &&
          other.caloriesEstimate == this.caloriesEstimate &&
          other.cookingMethod == this.cookingMethod &&
          other.timing == this.timing &&
          other.carbEstimateG == this.carbEstimateG &&
          other.fatEstimateG == this.fatEstimateG &&
          other.fiberEstimateG == this.fiberEstimateG);
}

class MealTemplatesCompanion extends UpdateCompanion<MealTemplate> {
  final Value<int> id;
  final Value<String> dayType;
  final Value<int> mealNumber;
  final Value<String> timeSlot;
  final Value<String> description;
  final Value<String> ingredients;
  final Value<double> proteinEstimateG;
  final Value<double> caloriesEstimate;
  final Value<String> cookingMethod;
  final Value<String> timing;
  final Value<double?> carbEstimateG;
  final Value<double?> fatEstimateG;
  final Value<double?> fiberEstimateG;
  const MealTemplatesCompanion({
    this.id = const Value.absent(),
    this.dayType = const Value.absent(),
    this.mealNumber = const Value.absent(),
    this.timeSlot = const Value.absent(),
    this.description = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.proteinEstimateG = const Value.absent(),
    this.caloriesEstimate = const Value.absent(),
    this.cookingMethod = const Value.absent(),
    this.timing = const Value.absent(),
    this.carbEstimateG = const Value.absent(),
    this.fatEstimateG = const Value.absent(),
    this.fiberEstimateG = const Value.absent(),
  });
  MealTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String dayType,
    required int mealNumber,
    required String timeSlot,
    required String description,
    required String ingredients,
    required double proteinEstimateG,
    required double caloriesEstimate,
    required String cookingMethod,
    required String timing,
    this.carbEstimateG = const Value.absent(),
    this.fatEstimateG = const Value.absent(),
    this.fiberEstimateG = const Value.absent(),
  }) : dayType = Value(dayType),
       mealNumber = Value(mealNumber),
       timeSlot = Value(timeSlot),
       description = Value(description),
       ingredients = Value(ingredients),
       proteinEstimateG = Value(proteinEstimateG),
       caloriesEstimate = Value(caloriesEstimate),
       cookingMethod = Value(cookingMethod),
       timing = Value(timing);
  static Insertable<MealTemplate> custom({
    Expression<int>? id,
    Expression<String>? dayType,
    Expression<int>? mealNumber,
    Expression<String>? timeSlot,
    Expression<String>? description,
    Expression<String>? ingredients,
    Expression<double>? proteinEstimateG,
    Expression<double>? caloriesEstimate,
    Expression<String>? cookingMethod,
    Expression<String>? timing,
    Expression<double>? carbEstimateG,
    Expression<double>? fatEstimateG,
    Expression<double>? fiberEstimateG,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayType != null) 'day_type': dayType,
      if (mealNumber != null) 'meal_number': mealNumber,
      if (timeSlot != null) 'time_slot': timeSlot,
      if (description != null) 'description': description,
      if (ingredients != null) 'ingredients': ingredients,
      if (proteinEstimateG != null) 'protein_estimate_g': proteinEstimateG,
      if (caloriesEstimate != null) 'calories_estimate': caloriesEstimate,
      if (cookingMethod != null) 'cooking_method': cookingMethod,
      if (timing != null) 'timing': timing,
      if (carbEstimateG != null) 'carb_estimate_g': carbEstimateG,
      if (fatEstimateG != null) 'fat_estimate_g': fatEstimateG,
      if (fiberEstimateG != null) 'fiber_estimate_g': fiberEstimateG,
    });
  }

  MealTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? dayType,
    Value<int>? mealNumber,
    Value<String>? timeSlot,
    Value<String>? description,
    Value<String>? ingredients,
    Value<double>? proteinEstimateG,
    Value<double>? caloriesEstimate,
    Value<String>? cookingMethod,
    Value<String>? timing,
    Value<double?>? carbEstimateG,
    Value<double?>? fatEstimateG,
    Value<double?>? fiberEstimateG,
  }) {
    return MealTemplatesCompanion(
      id: id ?? this.id,
      dayType: dayType ?? this.dayType,
      mealNumber: mealNumber ?? this.mealNumber,
      timeSlot: timeSlot ?? this.timeSlot,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      proteinEstimateG: proteinEstimateG ?? this.proteinEstimateG,
      caloriesEstimate: caloriesEstimate ?? this.caloriesEstimate,
      cookingMethod: cookingMethod ?? this.cookingMethod,
      timing: timing ?? this.timing,
      carbEstimateG: carbEstimateG ?? this.carbEstimateG,
      fatEstimateG: fatEstimateG ?? this.fatEstimateG,
      fiberEstimateG: fiberEstimateG ?? this.fiberEstimateG,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayType.present) {
      map['day_type'] = Variable<String>(dayType.value);
    }
    if (mealNumber.present) {
      map['meal_number'] = Variable<int>(mealNumber.value);
    }
    if (timeSlot.present) {
      map['time_slot'] = Variable<String>(timeSlot.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (ingredients.present) {
      map['ingredients'] = Variable<String>(ingredients.value);
    }
    if (proteinEstimateG.present) {
      map['protein_estimate_g'] = Variable<double>(proteinEstimateG.value);
    }
    if (caloriesEstimate.present) {
      map['calories_estimate'] = Variable<double>(caloriesEstimate.value);
    }
    if (cookingMethod.present) {
      map['cooking_method'] = Variable<String>(cookingMethod.value);
    }
    if (timing.present) {
      map['timing'] = Variable<String>(timing.value);
    }
    if (carbEstimateG.present) {
      map['carb_estimate_g'] = Variable<double>(carbEstimateG.value);
    }
    if (fatEstimateG.present) {
      map['fat_estimate_g'] = Variable<double>(fatEstimateG.value);
    }
    if (fiberEstimateG.present) {
      map['fiber_estimate_g'] = Variable<double>(fiberEstimateG.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('dayType: $dayType, ')
          ..write('mealNumber: $mealNumber, ')
          ..write('timeSlot: $timeSlot, ')
          ..write('description: $description, ')
          ..write('ingredients: $ingredients, ')
          ..write('proteinEstimateG: $proteinEstimateG, ')
          ..write('caloriesEstimate: $caloriesEstimate, ')
          ..write('cookingMethod: $cookingMethod, ')
          ..write('timing: $timing, ')
          ..write('carbEstimateG: $carbEstimateG, ')
          ..write('fatEstimateG: $fatEstimateG, ')
          ..write('fiberEstimateG: $fiberEstimateG')
          ..write(')'))
        .toString();
  }
}

class $AssessmentsTable extends Assessments
    with TableInfo<$AssessmentsTable, Assessment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssessmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pushupMaxRepsMeta = const VerificationMeta(
    'pushupMaxReps',
  );
  @override
  late final GeneratedColumn<int> pushupMaxReps = GeneratedColumn<int>(
    'pushup_max_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wallSitSecondsMeta = const VerificationMeta(
    'wallSitSeconds',
  );
  @override
  late final GeneratedColumn<int> wallSitSeconds = GeneratedColumn<int>(
    'wall_sit_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plankHoldSecondsMeta = const VerificationMeta(
    'plankHoldSeconds',
  );
  @override
  late final GeneratedColumn<int> plankHoldSeconds = GeneratedColumn<int>(
    'plank_hold_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sitAndReachCmMeta = const VerificationMeta(
    'sitAndReachCm',
  );
  @override
  late final GeneratedColumn<double> sitAndReachCm = GeneratedColumn<double>(
    'sit_and_reach_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cooperDistanceMMeta = const VerificationMeta(
    'cooperDistanceM',
  );
  @override
  late final GeneratedColumn<double> cooperDistanceM = GeneratedColumn<double>(
    'cooper_distance_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waistCmMeta = const VerificationMeta(
    'waistCm',
  );
  @override
  late final GeneratedColumn<double> waistCm = GeneratedColumn<double>(
    'waist_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chestCmMeta = const VerificationMeta(
    'chestCm',
  );
  @override
  late final GeneratedColumn<double> chestCm = GeneratedColumn<double>(
    'chest_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _armCmMeta = const VerificationMeta('armCm');
  @override
  late final GeneratedColumn<double> armCm = GeneratedColumn<double>(
    'arm_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _scoresJsonMeta = const VerificationMeta(
    'scoresJson',
  );
  @override
  late final GeneratedColumn<String> scoresJson = GeneratedColumn<String>(
    'scores_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    pushupMaxReps,
    wallSitSeconds,
    plankHoldSeconds,
    sitAndReachCm,
    cooperDistanceM,
    weightKg,
    waistCm,
    chestCm,
    armCm,
    notes,
    scoresJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assessments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Assessment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('pushup_max_reps')) {
      context.handle(
        _pushupMaxRepsMeta,
        pushupMaxReps.isAcceptableOrUnknown(
          data['pushup_max_reps']!,
          _pushupMaxRepsMeta,
        ),
      );
    }
    if (data.containsKey('wall_sit_seconds')) {
      context.handle(
        _wallSitSecondsMeta,
        wallSitSeconds.isAcceptableOrUnknown(
          data['wall_sit_seconds']!,
          _wallSitSecondsMeta,
        ),
      );
    }
    if (data.containsKey('plank_hold_seconds')) {
      context.handle(
        _plankHoldSecondsMeta,
        plankHoldSeconds.isAcceptableOrUnknown(
          data['plank_hold_seconds']!,
          _plankHoldSecondsMeta,
        ),
      );
    }
    if (data.containsKey('sit_and_reach_cm')) {
      context.handle(
        _sitAndReachCmMeta,
        sitAndReachCm.isAcceptableOrUnknown(
          data['sit_and_reach_cm']!,
          _sitAndReachCmMeta,
        ),
      );
    }
    if (data.containsKey('cooper_distance_m')) {
      context.handle(
        _cooperDistanceMMeta,
        cooperDistanceM.isAcceptableOrUnknown(
          data['cooper_distance_m']!,
          _cooperDistanceMMeta,
        ),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('waist_cm')) {
      context.handle(
        _waistCmMeta,
        waistCm.isAcceptableOrUnknown(data['waist_cm']!, _waistCmMeta),
      );
    }
    if (data.containsKey('chest_cm')) {
      context.handle(
        _chestCmMeta,
        chestCm.isAcceptableOrUnknown(data['chest_cm']!, _chestCmMeta),
      );
    }
    if (data.containsKey('arm_cm')) {
      context.handle(
        _armCmMeta,
        armCm.isAcceptableOrUnknown(data['arm_cm']!, _armCmMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('scores_json')) {
      context.handle(
        _scoresJsonMeta,
        scoresJson.isAcceptableOrUnknown(data['scores_json']!, _scoresJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Assessment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Assessment(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      pushupMaxReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pushup_max_reps'],
      ),
      wallSitSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wall_sit_seconds'],
      ),
      plankHoldSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plank_hold_seconds'],
      ),
      sitAndReachCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sit_and_reach_cm'],
      ),
      cooperDistanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cooper_distance_m'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      waistCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}waist_cm'],
      ),
      chestCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chest_cm'],
      ),
      armCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}arm_cm'],
      ),
      notes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notes'],
          )!,
      scoresJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}scores_json'],
          )!,
    );
  }

  @override
  $AssessmentsTable createAlias(String alias) {
    return $AssessmentsTable(attachedDatabase, alias);
  }
}

class Assessment extends DataClass implements Insertable<Assessment> {
  final int id;
  final DateTime date;
  final int? pushupMaxReps;
  final int? wallSitSeconds;
  final int? plankHoldSeconds;
  final double? sitAndReachCm;
  final double? cooperDistanceM;
  final double? weightKg;
  final double? waistCm;
  final double? chestCm;
  final double? armCm;
  final String notes;
  final String scoresJson;
  const Assessment({
    required this.id,
    required this.date,
    this.pushupMaxReps,
    this.wallSitSeconds,
    this.plankHoldSeconds,
    this.sitAndReachCm,
    this.cooperDistanceM,
    this.weightKg,
    this.waistCm,
    this.chestCm,
    this.armCm,
    required this.notes,
    required this.scoresJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || pushupMaxReps != null) {
      map['pushup_max_reps'] = Variable<int>(pushupMaxReps);
    }
    if (!nullToAbsent || wallSitSeconds != null) {
      map['wall_sit_seconds'] = Variable<int>(wallSitSeconds);
    }
    if (!nullToAbsent || plankHoldSeconds != null) {
      map['plank_hold_seconds'] = Variable<int>(plankHoldSeconds);
    }
    if (!nullToAbsent || sitAndReachCm != null) {
      map['sit_and_reach_cm'] = Variable<double>(sitAndReachCm);
    }
    if (!nullToAbsent || cooperDistanceM != null) {
      map['cooper_distance_m'] = Variable<double>(cooperDistanceM);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || waistCm != null) {
      map['waist_cm'] = Variable<double>(waistCm);
    }
    if (!nullToAbsent || chestCm != null) {
      map['chest_cm'] = Variable<double>(chestCm);
    }
    if (!nullToAbsent || armCm != null) {
      map['arm_cm'] = Variable<double>(armCm);
    }
    map['notes'] = Variable<String>(notes);
    map['scores_json'] = Variable<String>(scoresJson);
    return map;
  }

  AssessmentsCompanion toCompanion(bool nullToAbsent) {
    return AssessmentsCompanion(
      id: Value(id),
      date: Value(date),
      pushupMaxReps:
          pushupMaxReps == null && nullToAbsent
              ? const Value.absent()
              : Value(pushupMaxReps),
      wallSitSeconds:
          wallSitSeconds == null && nullToAbsent
              ? const Value.absent()
              : Value(wallSitSeconds),
      plankHoldSeconds:
          plankHoldSeconds == null && nullToAbsent
              ? const Value.absent()
              : Value(plankHoldSeconds),
      sitAndReachCm:
          sitAndReachCm == null && nullToAbsent
              ? const Value.absent()
              : Value(sitAndReachCm),
      cooperDistanceM:
          cooperDistanceM == null && nullToAbsent
              ? const Value.absent()
              : Value(cooperDistanceM),
      weightKg:
          weightKg == null && nullToAbsent
              ? const Value.absent()
              : Value(weightKg),
      waistCm:
          waistCm == null && nullToAbsent
              ? const Value.absent()
              : Value(waistCm),
      chestCm:
          chestCm == null && nullToAbsent
              ? const Value.absent()
              : Value(chestCm),
      armCm:
          armCm == null && nullToAbsent ? const Value.absent() : Value(armCm),
      notes: Value(notes),
      scoresJson: Value(scoresJson),
    );
  }

  factory Assessment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Assessment(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      pushupMaxReps: serializer.fromJson<int?>(json['pushupMaxReps']),
      wallSitSeconds: serializer.fromJson<int?>(json['wallSitSeconds']),
      plankHoldSeconds: serializer.fromJson<int?>(json['plankHoldSeconds']),
      sitAndReachCm: serializer.fromJson<double?>(json['sitAndReachCm']),
      cooperDistanceM: serializer.fromJson<double?>(json['cooperDistanceM']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      waistCm: serializer.fromJson<double?>(json['waistCm']),
      chestCm: serializer.fromJson<double?>(json['chestCm']),
      armCm: serializer.fromJson<double?>(json['armCm']),
      notes: serializer.fromJson<String>(json['notes']),
      scoresJson: serializer.fromJson<String>(json['scoresJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'pushupMaxReps': serializer.toJson<int?>(pushupMaxReps),
      'wallSitSeconds': serializer.toJson<int?>(wallSitSeconds),
      'plankHoldSeconds': serializer.toJson<int?>(plankHoldSeconds),
      'sitAndReachCm': serializer.toJson<double?>(sitAndReachCm),
      'cooperDistanceM': serializer.toJson<double?>(cooperDistanceM),
      'weightKg': serializer.toJson<double?>(weightKg),
      'waistCm': serializer.toJson<double?>(waistCm),
      'chestCm': serializer.toJson<double?>(chestCm),
      'armCm': serializer.toJson<double?>(armCm),
      'notes': serializer.toJson<String>(notes),
      'scoresJson': serializer.toJson<String>(scoresJson),
    };
  }

  Assessment copyWith({
    int? id,
    DateTime? date,
    Value<int?> pushupMaxReps = const Value.absent(),
    Value<int?> wallSitSeconds = const Value.absent(),
    Value<int?> plankHoldSeconds = const Value.absent(),
    Value<double?> sitAndReachCm = const Value.absent(),
    Value<double?> cooperDistanceM = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<double?> waistCm = const Value.absent(),
    Value<double?> chestCm = const Value.absent(),
    Value<double?> armCm = const Value.absent(),
    String? notes,
    String? scoresJson,
  }) => Assessment(
    id: id ?? this.id,
    date: date ?? this.date,
    pushupMaxReps:
        pushupMaxReps.present ? pushupMaxReps.value : this.pushupMaxReps,
    wallSitSeconds:
        wallSitSeconds.present ? wallSitSeconds.value : this.wallSitSeconds,
    plankHoldSeconds:
        plankHoldSeconds.present
            ? plankHoldSeconds.value
            : this.plankHoldSeconds,
    sitAndReachCm:
        sitAndReachCm.present ? sitAndReachCm.value : this.sitAndReachCm,
    cooperDistanceM:
        cooperDistanceM.present ? cooperDistanceM.value : this.cooperDistanceM,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    waistCm: waistCm.present ? waistCm.value : this.waistCm,
    chestCm: chestCm.present ? chestCm.value : this.chestCm,
    armCm: armCm.present ? armCm.value : this.armCm,
    notes: notes ?? this.notes,
    scoresJson: scoresJson ?? this.scoresJson,
  );
  Assessment copyWithCompanion(AssessmentsCompanion data) {
    return Assessment(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      pushupMaxReps:
          data.pushupMaxReps.present
              ? data.pushupMaxReps.value
              : this.pushupMaxReps,
      wallSitSeconds:
          data.wallSitSeconds.present
              ? data.wallSitSeconds.value
              : this.wallSitSeconds,
      plankHoldSeconds:
          data.plankHoldSeconds.present
              ? data.plankHoldSeconds.value
              : this.plankHoldSeconds,
      sitAndReachCm:
          data.sitAndReachCm.present
              ? data.sitAndReachCm.value
              : this.sitAndReachCm,
      cooperDistanceM:
          data.cooperDistanceM.present
              ? data.cooperDistanceM.value
              : this.cooperDistanceM,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      waistCm: data.waistCm.present ? data.waistCm.value : this.waistCm,
      chestCm: data.chestCm.present ? data.chestCm.value : this.chestCm,
      armCm: data.armCm.present ? data.armCm.value : this.armCm,
      notes: data.notes.present ? data.notes.value : this.notes,
      scoresJson:
          data.scoresJson.present ? data.scoresJson.value : this.scoresJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Assessment(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('pushupMaxReps: $pushupMaxReps, ')
          ..write('wallSitSeconds: $wallSitSeconds, ')
          ..write('plankHoldSeconds: $plankHoldSeconds, ')
          ..write('sitAndReachCm: $sitAndReachCm, ')
          ..write('cooperDistanceM: $cooperDistanceM, ')
          ..write('weightKg: $weightKg, ')
          ..write('waistCm: $waistCm, ')
          ..write('chestCm: $chestCm, ')
          ..write('armCm: $armCm, ')
          ..write('notes: $notes, ')
          ..write('scoresJson: $scoresJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    pushupMaxReps,
    wallSitSeconds,
    plankHoldSeconds,
    sitAndReachCm,
    cooperDistanceM,
    weightKg,
    waistCm,
    chestCm,
    armCm,
    notes,
    scoresJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Assessment &&
          other.id == this.id &&
          other.date == this.date &&
          other.pushupMaxReps == this.pushupMaxReps &&
          other.wallSitSeconds == this.wallSitSeconds &&
          other.plankHoldSeconds == this.plankHoldSeconds &&
          other.sitAndReachCm == this.sitAndReachCm &&
          other.cooperDistanceM == this.cooperDistanceM &&
          other.weightKg == this.weightKg &&
          other.waistCm == this.waistCm &&
          other.chestCm == this.chestCm &&
          other.armCm == this.armCm &&
          other.notes == this.notes &&
          other.scoresJson == this.scoresJson);
}

class AssessmentsCompanion extends UpdateCompanion<Assessment> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int?> pushupMaxReps;
  final Value<int?> wallSitSeconds;
  final Value<int?> plankHoldSeconds;
  final Value<double?> sitAndReachCm;
  final Value<double?> cooperDistanceM;
  final Value<double?> weightKg;
  final Value<double?> waistCm;
  final Value<double?> chestCm;
  final Value<double?> armCm;
  final Value<String> notes;
  final Value<String> scoresJson;
  const AssessmentsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.pushupMaxReps = const Value.absent(),
    this.wallSitSeconds = const Value.absent(),
    this.plankHoldSeconds = const Value.absent(),
    this.sitAndReachCm = const Value.absent(),
    this.cooperDistanceM = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.chestCm = const Value.absent(),
    this.armCm = const Value.absent(),
    this.notes = const Value.absent(),
    this.scoresJson = const Value.absent(),
  });
  AssessmentsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.pushupMaxReps = const Value.absent(),
    this.wallSitSeconds = const Value.absent(),
    this.plankHoldSeconds = const Value.absent(),
    this.sitAndReachCm = const Value.absent(),
    this.cooperDistanceM = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.chestCm = const Value.absent(),
    this.armCm = const Value.absent(),
    this.notes = const Value.absent(),
    this.scoresJson = const Value.absent(),
  }) : date = Value(date);
  static Insertable<Assessment> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? pushupMaxReps,
    Expression<int>? wallSitSeconds,
    Expression<int>? plankHoldSeconds,
    Expression<double>? sitAndReachCm,
    Expression<double>? cooperDistanceM,
    Expression<double>? weightKg,
    Expression<double>? waistCm,
    Expression<double>? chestCm,
    Expression<double>? armCm,
    Expression<String>? notes,
    Expression<String>? scoresJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (pushupMaxReps != null) 'pushup_max_reps': pushupMaxReps,
      if (wallSitSeconds != null) 'wall_sit_seconds': wallSitSeconds,
      if (plankHoldSeconds != null) 'plank_hold_seconds': plankHoldSeconds,
      if (sitAndReachCm != null) 'sit_and_reach_cm': sitAndReachCm,
      if (cooperDistanceM != null) 'cooper_distance_m': cooperDistanceM,
      if (weightKg != null) 'weight_kg': weightKg,
      if (waistCm != null) 'waist_cm': waistCm,
      if (chestCm != null) 'chest_cm': chestCm,
      if (armCm != null) 'arm_cm': armCm,
      if (notes != null) 'notes': notes,
      if (scoresJson != null) 'scores_json': scoresJson,
    });
  }

  AssessmentsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int?>? pushupMaxReps,
    Value<int?>? wallSitSeconds,
    Value<int?>? plankHoldSeconds,
    Value<double?>? sitAndReachCm,
    Value<double?>? cooperDistanceM,
    Value<double?>? weightKg,
    Value<double?>? waistCm,
    Value<double?>? chestCm,
    Value<double?>? armCm,
    Value<String>? notes,
    Value<String>? scoresJson,
  }) {
    return AssessmentsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      pushupMaxReps: pushupMaxReps ?? this.pushupMaxReps,
      wallSitSeconds: wallSitSeconds ?? this.wallSitSeconds,
      plankHoldSeconds: plankHoldSeconds ?? this.plankHoldSeconds,
      sitAndReachCm: sitAndReachCm ?? this.sitAndReachCm,
      cooperDistanceM: cooperDistanceM ?? this.cooperDistanceM,
      weightKg: weightKg ?? this.weightKg,
      waistCm: waistCm ?? this.waistCm,
      chestCm: chestCm ?? this.chestCm,
      armCm: armCm ?? this.armCm,
      notes: notes ?? this.notes,
      scoresJson: scoresJson ?? this.scoresJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (pushupMaxReps.present) {
      map['pushup_max_reps'] = Variable<int>(pushupMaxReps.value);
    }
    if (wallSitSeconds.present) {
      map['wall_sit_seconds'] = Variable<int>(wallSitSeconds.value);
    }
    if (plankHoldSeconds.present) {
      map['plank_hold_seconds'] = Variable<int>(plankHoldSeconds.value);
    }
    if (sitAndReachCm.present) {
      map['sit_and_reach_cm'] = Variable<double>(sitAndReachCm.value);
    }
    if (cooperDistanceM.present) {
      map['cooper_distance_m'] = Variable<double>(cooperDistanceM.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (waistCm.present) {
      map['waist_cm'] = Variable<double>(waistCm.value);
    }
    if (chestCm.present) {
      map['chest_cm'] = Variable<double>(chestCm.value);
    }
    if (armCm.present) {
      map['arm_cm'] = Variable<double>(armCm.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (scoresJson.present) {
      map['scores_json'] = Variable<String>(scoresJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssessmentsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('pushupMaxReps: $pushupMaxReps, ')
          ..write('wallSitSeconds: $wallSitSeconds, ')
          ..write('plankHoldSeconds: $plankHoldSeconds, ')
          ..write('sitAndReachCm: $sitAndReachCm, ')
          ..write('cooperDistanceM: $cooperDistanceM, ')
          ..write('weightKg: $weightKg, ')
          ..write('waistCm: $waistCm, ')
          ..write('chestCm: $chestCm, ')
          ..write('armCm: $armCm, ')
          ..write('notes: $notes, ')
          ..write('scoresJson: $scoresJson')
          ..write(')'))
        .toString();
  }
}

class $ResearchFeedTable extends ResearchFeed
    with TableInfo<$ResearchFeedTable, ResearchFeedData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResearchFeedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _foundDateMeta = const VerificationMeta(
    'foundDate',
  );
  @override
  late final GeneratedColumn<DateTime> foundDate = GeneratedColumn<DateTime>(
    'found_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abstractTextMeta = const VerificationMeta(
    'abstractText',
  );
  @override
  late final GeneratedColumn<String> abstractText = GeneratedColumn<String>(
    'abstract_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doiMeta = const VerificationMeta('doi');
  @override
  late final GeneratedColumn<String> doi = GeneratedColumn<String>(
    'doi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keySummaryMeta = const VerificationMeta(
    'keySummary',
  );
  @override
  late final GeneratedColumn<String> keySummary = GeneratedColumn<String>(
    'key_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _impactMeta = const VerificationMeta('impact');
  @override
  late final GeneratedColumn<String> impact = GeneratedColumn<String>(
    'impact',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userReadMeta = const VerificationMeta(
    'userRead',
  );
  @override
  late final GeneratedColumn<bool> userRead = GeneratedColumn<bool>(
    'user_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _proposedUpdateMeta = const VerificationMeta(
    'proposedUpdate',
  );
  @override
  late final GeneratedColumn<bool> proposedUpdate = GeneratedColumn<bool>(
    'proposed_update',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("proposed_update" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updateProposalMeta = const VerificationMeta(
    'updateProposal',
  );
  @override
  late final GeneratedColumn<String> updateProposal = GeneratedColumn<String>(
    'update_proposal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updateStatusMeta = const VerificationMeta(
    'updateStatus',
  );
  @override
  late final GeneratedColumn<String> updateStatus = GeneratedColumn<String>(
    'update_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    foundDate,
    source,
    language,
    title,
    abstractText,
    doi,
    url,
    area,
    keySummary,
    impact,
    userRead,
    proposedUpdate,
    updateProposal,
    updateStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'research_feed';
  @override
  VerificationContext validateIntegrity(
    Insertable<ResearchFeedData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('found_date')) {
      context.handle(
        _foundDateMeta,
        foundDate.isAcceptableOrUnknown(data['found_date']!, _foundDateMeta),
      );
    } else if (isInserting) {
      context.missing(_foundDateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('abstract_text')) {
      context.handle(
        _abstractTextMeta,
        abstractText.isAcceptableOrUnknown(
          data['abstract_text']!,
          _abstractTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_abstractTextMeta);
    }
    if (data.containsKey('doi')) {
      context.handle(
        _doiMeta,
        doi.isAcceptableOrUnknown(data['doi']!, _doiMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    } else if (isInserting) {
      context.missing(_areaMeta);
    }
    if (data.containsKey('key_summary')) {
      context.handle(
        _keySummaryMeta,
        keySummary.isAcceptableOrUnknown(data['key_summary']!, _keySummaryMeta),
      );
    } else if (isInserting) {
      context.missing(_keySummaryMeta);
    }
    if (data.containsKey('impact')) {
      context.handle(
        _impactMeta,
        impact.isAcceptableOrUnknown(data['impact']!, _impactMeta),
      );
    } else if (isInserting) {
      context.missing(_impactMeta);
    }
    if (data.containsKey('user_read')) {
      context.handle(
        _userReadMeta,
        userRead.isAcceptableOrUnknown(data['user_read']!, _userReadMeta),
      );
    }
    if (data.containsKey('proposed_update')) {
      context.handle(
        _proposedUpdateMeta,
        proposedUpdate.isAcceptableOrUnknown(
          data['proposed_update']!,
          _proposedUpdateMeta,
        ),
      );
    }
    if (data.containsKey('update_proposal')) {
      context.handle(
        _updateProposalMeta,
        updateProposal.isAcceptableOrUnknown(
          data['update_proposal']!,
          _updateProposalMeta,
        ),
      );
    }
    if (data.containsKey('update_status')) {
      context.handle(
        _updateStatusMeta,
        updateStatus.isAcceptableOrUnknown(
          data['update_status']!,
          _updateStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResearchFeedData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResearchFeedData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      foundDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}found_date'],
          )!,
      source:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source'],
          )!,
      language:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}language'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      abstractText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}abstract_text'],
          )!,
      doi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doi'],
      ),
      url:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}url'],
          )!,
      area:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}area'],
          )!,
      keySummary:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key_summary'],
          )!,
      impact:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}impact'],
          )!,
      userRead:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}user_read'],
          )!,
      proposedUpdate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}proposed_update'],
          )!,
      updateProposal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}update_proposal'],
      ),
      updateStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}update_status'],
      ),
    );
  }

  @override
  $ResearchFeedTable createAlias(String alias) {
    return $ResearchFeedTable(attachedDatabase, alias);
  }
}

class ResearchFeedData extends DataClass
    implements Insertable<ResearchFeedData> {
  final int id;
  final DateTime foundDate;
  final String source;
  final String language;
  final String title;
  final String abstractText;
  final String? doi;
  final String url;
  final String area;
  final String keySummary;
  final String impact;
  final bool userRead;
  final bool proposedUpdate;
  final String? updateProposal;
  final String? updateStatus;
  const ResearchFeedData({
    required this.id,
    required this.foundDate,
    required this.source,
    required this.language,
    required this.title,
    required this.abstractText,
    this.doi,
    required this.url,
    required this.area,
    required this.keySummary,
    required this.impact,
    required this.userRead,
    required this.proposedUpdate,
    this.updateProposal,
    this.updateStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['found_date'] = Variable<DateTime>(foundDate);
    map['source'] = Variable<String>(source);
    map['language'] = Variable<String>(language);
    map['title'] = Variable<String>(title);
    map['abstract_text'] = Variable<String>(abstractText);
    if (!nullToAbsent || doi != null) {
      map['doi'] = Variable<String>(doi);
    }
    map['url'] = Variable<String>(url);
    map['area'] = Variable<String>(area);
    map['key_summary'] = Variable<String>(keySummary);
    map['impact'] = Variable<String>(impact);
    map['user_read'] = Variable<bool>(userRead);
    map['proposed_update'] = Variable<bool>(proposedUpdate);
    if (!nullToAbsent || updateProposal != null) {
      map['update_proposal'] = Variable<String>(updateProposal);
    }
    if (!nullToAbsent || updateStatus != null) {
      map['update_status'] = Variable<String>(updateStatus);
    }
    return map;
  }

  ResearchFeedCompanion toCompanion(bool nullToAbsent) {
    return ResearchFeedCompanion(
      id: Value(id),
      foundDate: Value(foundDate),
      source: Value(source),
      language: Value(language),
      title: Value(title),
      abstractText: Value(abstractText),
      doi: doi == null && nullToAbsent ? const Value.absent() : Value(doi),
      url: Value(url),
      area: Value(area),
      keySummary: Value(keySummary),
      impact: Value(impact),
      userRead: Value(userRead),
      proposedUpdate: Value(proposedUpdate),
      updateProposal:
          updateProposal == null && nullToAbsent
              ? const Value.absent()
              : Value(updateProposal),
      updateStatus:
          updateStatus == null && nullToAbsent
              ? const Value.absent()
              : Value(updateStatus),
    );
  }

  factory ResearchFeedData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResearchFeedData(
      id: serializer.fromJson<int>(json['id']),
      foundDate: serializer.fromJson<DateTime>(json['foundDate']),
      source: serializer.fromJson<String>(json['source']),
      language: serializer.fromJson<String>(json['language']),
      title: serializer.fromJson<String>(json['title']),
      abstractText: serializer.fromJson<String>(json['abstractText']),
      doi: serializer.fromJson<String?>(json['doi']),
      url: serializer.fromJson<String>(json['url']),
      area: serializer.fromJson<String>(json['area']),
      keySummary: serializer.fromJson<String>(json['keySummary']),
      impact: serializer.fromJson<String>(json['impact']),
      userRead: serializer.fromJson<bool>(json['userRead']),
      proposedUpdate: serializer.fromJson<bool>(json['proposedUpdate']),
      updateProposal: serializer.fromJson<String?>(json['updateProposal']),
      updateStatus: serializer.fromJson<String?>(json['updateStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'foundDate': serializer.toJson<DateTime>(foundDate),
      'source': serializer.toJson<String>(source),
      'language': serializer.toJson<String>(language),
      'title': serializer.toJson<String>(title),
      'abstractText': serializer.toJson<String>(abstractText),
      'doi': serializer.toJson<String?>(doi),
      'url': serializer.toJson<String>(url),
      'area': serializer.toJson<String>(area),
      'keySummary': serializer.toJson<String>(keySummary),
      'impact': serializer.toJson<String>(impact),
      'userRead': serializer.toJson<bool>(userRead),
      'proposedUpdate': serializer.toJson<bool>(proposedUpdate),
      'updateProposal': serializer.toJson<String?>(updateProposal),
      'updateStatus': serializer.toJson<String?>(updateStatus),
    };
  }

  ResearchFeedData copyWith({
    int? id,
    DateTime? foundDate,
    String? source,
    String? language,
    String? title,
    String? abstractText,
    Value<String?> doi = const Value.absent(),
    String? url,
    String? area,
    String? keySummary,
    String? impact,
    bool? userRead,
    bool? proposedUpdate,
    Value<String?> updateProposal = const Value.absent(),
    Value<String?> updateStatus = const Value.absent(),
  }) => ResearchFeedData(
    id: id ?? this.id,
    foundDate: foundDate ?? this.foundDate,
    source: source ?? this.source,
    language: language ?? this.language,
    title: title ?? this.title,
    abstractText: abstractText ?? this.abstractText,
    doi: doi.present ? doi.value : this.doi,
    url: url ?? this.url,
    area: area ?? this.area,
    keySummary: keySummary ?? this.keySummary,
    impact: impact ?? this.impact,
    userRead: userRead ?? this.userRead,
    proposedUpdate: proposedUpdate ?? this.proposedUpdate,
    updateProposal:
        updateProposal.present ? updateProposal.value : this.updateProposal,
    updateStatus: updateStatus.present ? updateStatus.value : this.updateStatus,
  );
  ResearchFeedData copyWithCompanion(ResearchFeedCompanion data) {
    return ResearchFeedData(
      id: data.id.present ? data.id.value : this.id,
      foundDate: data.foundDate.present ? data.foundDate.value : this.foundDate,
      source: data.source.present ? data.source.value : this.source,
      language: data.language.present ? data.language.value : this.language,
      title: data.title.present ? data.title.value : this.title,
      abstractText:
          data.abstractText.present
              ? data.abstractText.value
              : this.abstractText,
      doi: data.doi.present ? data.doi.value : this.doi,
      url: data.url.present ? data.url.value : this.url,
      area: data.area.present ? data.area.value : this.area,
      keySummary:
          data.keySummary.present ? data.keySummary.value : this.keySummary,
      impact: data.impact.present ? data.impact.value : this.impact,
      userRead: data.userRead.present ? data.userRead.value : this.userRead,
      proposedUpdate:
          data.proposedUpdate.present
              ? data.proposedUpdate.value
              : this.proposedUpdate,
      updateProposal:
          data.updateProposal.present
              ? data.updateProposal.value
              : this.updateProposal,
      updateStatus:
          data.updateStatus.present
              ? data.updateStatus.value
              : this.updateStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResearchFeedData(')
          ..write('id: $id, ')
          ..write('foundDate: $foundDate, ')
          ..write('source: $source, ')
          ..write('language: $language, ')
          ..write('title: $title, ')
          ..write('abstractText: $abstractText, ')
          ..write('doi: $doi, ')
          ..write('url: $url, ')
          ..write('area: $area, ')
          ..write('keySummary: $keySummary, ')
          ..write('impact: $impact, ')
          ..write('userRead: $userRead, ')
          ..write('proposedUpdate: $proposedUpdate, ')
          ..write('updateProposal: $updateProposal, ')
          ..write('updateStatus: $updateStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    foundDate,
    source,
    language,
    title,
    abstractText,
    doi,
    url,
    area,
    keySummary,
    impact,
    userRead,
    proposedUpdate,
    updateProposal,
    updateStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResearchFeedData &&
          other.id == this.id &&
          other.foundDate == this.foundDate &&
          other.source == this.source &&
          other.language == this.language &&
          other.title == this.title &&
          other.abstractText == this.abstractText &&
          other.doi == this.doi &&
          other.url == this.url &&
          other.area == this.area &&
          other.keySummary == this.keySummary &&
          other.impact == this.impact &&
          other.userRead == this.userRead &&
          other.proposedUpdate == this.proposedUpdate &&
          other.updateProposal == this.updateProposal &&
          other.updateStatus == this.updateStatus);
}

class ResearchFeedCompanion extends UpdateCompanion<ResearchFeedData> {
  final Value<int> id;
  final Value<DateTime> foundDate;
  final Value<String> source;
  final Value<String> language;
  final Value<String> title;
  final Value<String> abstractText;
  final Value<String?> doi;
  final Value<String> url;
  final Value<String> area;
  final Value<String> keySummary;
  final Value<String> impact;
  final Value<bool> userRead;
  final Value<bool> proposedUpdate;
  final Value<String?> updateProposal;
  final Value<String?> updateStatus;
  const ResearchFeedCompanion({
    this.id = const Value.absent(),
    this.foundDate = const Value.absent(),
    this.source = const Value.absent(),
    this.language = const Value.absent(),
    this.title = const Value.absent(),
    this.abstractText = const Value.absent(),
    this.doi = const Value.absent(),
    this.url = const Value.absent(),
    this.area = const Value.absent(),
    this.keySummary = const Value.absent(),
    this.impact = const Value.absent(),
    this.userRead = const Value.absent(),
    this.proposedUpdate = const Value.absent(),
    this.updateProposal = const Value.absent(),
    this.updateStatus = const Value.absent(),
  });
  ResearchFeedCompanion.insert({
    this.id = const Value.absent(),
    required DateTime foundDate,
    required String source,
    required String language,
    required String title,
    required String abstractText,
    this.doi = const Value.absent(),
    required String url,
    required String area,
    required String keySummary,
    required String impact,
    this.userRead = const Value.absent(),
    this.proposedUpdate = const Value.absent(),
    this.updateProposal = const Value.absent(),
    this.updateStatus = const Value.absent(),
  }) : foundDate = Value(foundDate),
       source = Value(source),
       language = Value(language),
       title = Value(title),
       abstractText = Value(abstractText),
       url = Value(url),
       area = Value(area),
       keySummary = Value(keySummary),
       impact = Value(impact);
  static Insertable<ResearchFeedData> custom({
    Expression<int>? id,
    Expression<DateTime>? foundDate,
    Expression<String>? source,
    Expression<String>? language,
    Expression<String>? title,
    Expression<String>? abstractText,
    Expression<String>? doi,
    Expression<String>? url,
    Expression<String>? area,
    Expression<String>? keySummary,
    Expression<String>? impact,
    Expression<bool>? userRead,
    Expression<bool>? proposedUpdate,
    Expression<String>? updateProposal,
    Expression<String>? updateStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foundDate != null) 'found_date': foundDate,
      if (source != null) 'source': source,
      if (language != null) 'language': language,
      if (title != null) 'title': title,
      if (abstractText != null) 'abstract_text': abstractText,
      if (doi != null) 'doi': doi,
      if (url != null) 'url': url,
      if (area != null) 'area': area,
      if (keySummary != null) 'key_summary': keySummary,
      if (impact != null) 'impact': impact,
      if (userRead != null) 'user_read': userRead,
      if (proposedUpdate != null) 'proposed_update': proposedUpdate,
      if (updateProposal != null) 'update_proposal': updateProposal,
      if (updateStatus != null) 'update_status': updateStatus,
    });
  }

  ResearchFeedCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? foundDate,
    Value<String>? source,
    Value<String>? language,
    Value<String>? title,
    Value<String>? abstractText,
    Value<String?>? doi,
    Value<String>? url,
    Value<String>? area,
    Value<String>? keySummary,
    Value<String>? impact,
    Value<bool>? userRead,
    Value<bool>? proposedUpdate,
    Value<String?>? updateProposal,
    Value<String?>? updateStatus,
  }) {
    return ResearchFeedCompanion(
      id: id ?? this.id,
      foundDate: foundDate ?? this.foundDate,
      source: source ?? this.source,
      language: language ?? this.language,
      title: title ?? this.title,
      abstractText: abstractText ?? this.abstractText,
      doi: doi ?? this.doi,
      url: url ?? this.url,
      area: area ?? this.area,
      keySummary: keySummary ?? this.keySummary,
      impact: impact ?? this.impact,
      userRead: userRead ?? this.userRead,
      proposedUpdate: proposedUpdate ?? this.proposedUpdate,
      updateProposal: updateProposal ?? this.updateProposal,
      updateStatus: updateStatus ?? this.updateStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (foundDate.present) {
      map['found_date'] = Variable<DateTime>(foundDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (abstractText.present) {
      map['abstract_text'] = Variable<String>(abstractText.value);
    }
    if (doi.present) {
      map['doi'] = Variable<String>(doi.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (keySummary.present) {
      map['key_summary'] = Variable<String>(keySummary.value);
    }
    if (impact.present) {
      map['impact'] = Variable<String>(impact.value);
    }
    if (userRead.present) {
      map['user_read'] = Variable<bool>(userRead.value);
    }
    if (proposedUpdate.present) {
      map['proposed_update'] = Variable<bool>(proposedUpdate.value);
    }
    if (updateProposal.present) {
      map['update_proposal'] = Variable<String>(updateProposal.value);
    }
    if (updateStatus.present) {
      map['update_status'] = Variable<String>(updateStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResearchFeedCompanion(')
          ..write('id: $id, ')
          ..write('foundDate: $foundDate, ')
          ..write('source: $source, ')
          ..write('language: $language, ')
          ..write('title: $title, ')
          ..write('abstractText: $abstractText, ')
          ..write('doi: $doi, ')
          ..write('url: $url, ')
          ..write('area: $area, ')
          ..write('keySummary: $keySummary, ')
          ..write('impact: $impact, ')
          ..write('userRead: $userRead, ')
          ..write('proposedUpdate: $proposedUpdate, ')
          ..write('updateProposal: $updateProposal, ')
          ..write('updateStatus: $updateStatus')
          ..write(')'))
        .toString();
  }
}

class $CardioSessionsTable extends CardioSessions
    with TableInfo<$CardioSessionsTable, CardioSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardioSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protocolMeta = const VerificationMeta(
    'protocol',
  );
  @override
  late final GeneratedColumn<String> protocol = GeneratedColumn<String>(
    'protocol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roundsCompletedMeta = const VerificationMeta(
    'roundsCompleted',
  );
  @override
  late final GeneratedColumn<int> roundsCompleted = GeneratedColumn<int>(
    'rounds_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _roundsTotalMeta = const VerificationMeta(
    'roundsTotal',
  );
  @override
  late final GeneratedColumn<int> roundsTotal = GeneratedColumn<int>(
    'rounds_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalDurationSecondsMeta =
      const VerificationMeta('totalDurationSeconds');
  @override
  late final GeneratedColumn<int> totalDurationSeconds = GeneratedColumn<int>(
    'total_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _zone2MinutesMeta = const VerificationMeta(
    'zone2Minutes',
  );
  @override
  late final GeneratedColumn<int> zone2Minutes = GeneratedColumn<int>(
    'zone2_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _avgHrEstimatedMeta = const VerificationMeta(
    'avgHrEstimated',
  );
  @override
  late final GeneratedColumn<int> avgHrEstimated = GeneratedColumn<int>(
    'avg_hr_estimated',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _perceivedExertionMeta = const VerificationMeta(
    'perceivedExertion',
  );
  @override
  late final GeneratedColumn<int> perceivedExertion = GeneratedColumn<int>(
    'perceived_exertion',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modalityMeta = const VerificationMeta(
    'modality',
  );
  @override
  late final GeneratedColumn<String> modality = GeneratedColumn<String>(
    'modality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bodyweight'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    protocol,
    roundsCompleted,
    roundsTotal,
    totalDurationSeconds,
    zone2Minutes,
    avgHrEstimated,
    perceivedExertion,
    modality,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cardio_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardioSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('protocol')) {
      context.handle(
        _protocolMeta,
        protocol.isAcceptableOrUnknown(data['protocol']!, _protocolMeta),
      );
    } else if (isInserting) {
      context.missing(_protocolMeta);
    }
    if (data.containsKey('rounds_completed')) {
      context.handle(
        _roundsCompletedMeta,
        roundsCompleted.isAcceptableOrUnknown(
          data['rounds_completed']!,
          _roundsCompletedMeta,
        ),
      );
    }
    if (data.containsKey('rounds_total')) {
      context.handle(
        _roundsTotalMeta,
        roundsTotal.isAcceptableOrUnknown(
          data['rounds_total']!,
          _roundsTotalMeta,
        ),
      );
    }
    if (data.containsKey('total_duration_seconds')) {
      context.handle(
        _totalDurationSecondsMeta,
        totalDurationSeconds.isAcceptableOrUnknown(
          data['total_duration_seconds']!,
          _totalDurationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('zone2_minutes')) {
      context.handle(
        _zone2MinutesMeta,
        zone2Minutes.isAcceptableOrUnknown(
          data['zone2_minutes']!,
          _zone2MinutesMeta,
        ),
      );
    }
    if (data.containsKey('avg_hr_estimated')) {
      context.handle(
        _avgHrEstimatedMeta,
        avgHrEstimated.isAcceptableOrUnknown(
          data['avg_hr_estimated']!,
          _avgHrEstimatedMeta,
        ),
      );
    }
    if (data.containsKey('perceived_exertion')) {
      context.handle(
        _perceivedExertionMeta,
        perceivedExertion.isAcceptableOrUnknown(
          data['perceived_exertion']!,
          _perceivedExertionMeta,
        ),
      );
    }
    if (data.containsKey('modality')) {
      context.handle(
        _modalityMeta,
        modality.isAcceptableOrUnknown(data['modality']!, _modalityMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardioSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardioSession(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      protocol:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}protocol'],
          )!,
      roundsCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}rounds_completed'],
          )!,
      roundsTotal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}rounds_total'],
          )!,
      totalDurationSeconds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_duration_seconds'],
          )!,
      zone2Minutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}zone2_minutes'],
          )!,
      avgHrEstimated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_hr_estimated'],
      ),
      perceivedExertion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}perceived_exertion'],
      ),
      modality:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}modality'],
          )!,
      notes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notes'],
          )!,
    );
  }

  @override
  $CardioSessionsTable createAlias(String alias) {
    return $CardioSessionsTable(attachedDatabase, alias);
  }
}

class CardioSession extends DataClass implements Insertable<CardioSession> {
  final int id;
  final DateTime date;
  final String protocol;
  final int roundsCompleted;
  final int roundsTotal;
  final int totalDurationSeconds;
  final int zone2Minutes;
  final int? avgHrEstimated;
  final int? perceivedExertion;
  final String modality;
  final String notes;
  const CardioSession({
    required this.id,
    required this.date,
    required this.protocol,
    required this.roundsCompleted,
    required this.roundsTotal,
    required this.totalDurationSeconds,
    required this.zone2Minutes,
    this.avgHrEstimated,
    this.perceivedExertion,
    required this.modality,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['protocol'] = Variable<String>(protocol);
    map['rounds_completed'] = Variable<int>(roundsCompleted);
    map['rounds_total'] = Variable<int>(roundsTotal);
    map['total_duration_seconds'] = Variable<int>(totalDurationSeconds);
    map['zone2_minutes'] = Variable<int>(zone2Minutes);
    if (!nullToAbsent || avgHrEstimated != null) {
      map['avg_hr_estimated'] = Variable<int>(avgHrEstimated);
    }
    if (!nullToAbsent || perceivedExertion != null) {
      map['perceived_exertion'] = Variable<int>(perceivedExertion);
    }
    map['modality'] = Variable<String>(modality);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  CardioSessionsCompanion toCompanion(bool nullToAbsent) {
    return CardioSessionsCompanion(
      id: Value(id),
      date: Value(date),
      protocol: Value(protocol),
      roundsCompleted: Value(roundsCompleted),
      roundsTotal: Value(roundsTotal),
      totalDurationSeconds: Value(totalDurationSeconds),
      zone2Minutes: Value(zone2Minutes),
      avgHrEstimated:
          avgHrEstimated == null && nullToAbsent
              ? const Value.absent()
              : Value(avgHrEstimated),
      perceivedExertion:
          perceivedExertion == null && nullToAbsent
              ? const Value.absent()
              : Value(perceivedExertion),
      modality: Value(modality),
      notes: Value(notes),
    );
  }

  factory CardioSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardioSession(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      protocol: serializer.fromJson<String>(json['protocol']),
      roundsCompleted: serializer.fromJson<int>(json['roundsCompleted']),
      roundsTotal: serializer.fromJson<int>(json['roundsTotal']),
      totalDurationSeconds: serializer.fromJson<int>(
        json['totalDurationSeconds'],
      ),
      zone2Minutes: serializer.fromJson<int>(json['zone2Minutes']),
      avgHrEstimated: serializer.fromJson<int?>(json['avgHrEstimated']),
      perceivedExertion: serializer.fromJson<int?>(json['perceivedExertion']),
      modality: serializer.fromJson<String>(json['modality']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'protocol': serializer.toJson<String>(protocol),
      'roundsCompleted': serializer.toJson<int>(roundsCompleted),
      'roundsTotal': serializer.toJson<int>(roundsTotal),
      'totalDurationSeconds': serializer.toJson<int>(totalDurationSeconds),
      'zone2Minutes': serializer.toJson<int>(zone2Minutes),
      'avgHrEstimated': serializer.toJson<int?>(avgHrEstimated),
      'perceivedExertion': serializer.toJson<int?>(perceivedExertion),
      'modality': serializer.toJson<String>(modality),
      'notes': serializer.toJson<String>(notes),
    };
  }

  CardioSession copyWith({
    int? id,
    DateTime? date,
    String? protocol,
    int? roundsCompleted,
    int? roundsTotal,
    int? totalDurationSeconds,
    int? zone2Minutes,
    Value<int?> avgHrEstimated = const Value.absent(),
    Value<int?> perceivedExertion = const Value.absent(),
    String? modality,
    String? notes,
  }) => CardioSession(
    id: id ?? this.id,
    date: date ?? this.date,
    protocol: protocol ?? this.protocol,
    roundsCompleted: roundsCompleted ?? this.roundsCompleted,
    roundsTotal: roundsTotal ?? this.roundsTotal,
    totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
    zone2Minutes: zone2Minutes ?? this.zone2Minutes,
    avgHrEstimated:
        avgHrEstimated.present ? avgHrEstimated.value : this.avgHrEstimated,
    perceivedExertion:
        perceivedExertion.present
            ? perceivedExertion.value
            : this.perceivedExertion,
    modality: modality ?? this.modality,
    notes: notes ?? this.notes,
  );
  CardioSession copyWithCompanion(CardioSessionsCompanion data) {
    return CardioSession(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      protocol: data.protocol.present ? data.protocol.value : this.protocol,
      roundsCompleted:
          data.roundsCompleted.present
              ? data.roundsCompleted.value
              : this.roundsCompleted,
      roundsTotal:
          data.roundsTotal.present ? data.roundsTotal.value : this.roundsTotal,
      totalDurationSeconds:
          data.totalDurationSeconds.present
              ? data.totalDurationSeconds.value
              : this.totalDurationSeconds,
      zone2Minutes:
          data.zone2Minutes.present
              ? data.zone2Minutes.value
              : this.zone2Minutes,
      avgHrEstimated:
          data.avgHrEstimated.present
              ? data.avgHrEstimated.value
              : this.avgHrEstimated,
      perceivedExertion:
          data.perceivedExertion.present
              ? data.perceivedExertion.value
              : this.perceivedExertion,
      modality: data.modality.present ? data.modality.value : this.modality,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardioSession(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('protocol: $protocol, ')
          ..write('roundsCompleted: $roundsCompleted, ')
          ..write('roundsTotal: $roundsTotal, ')
          ..write('totalDurationSeconds: $totalDurationSeconds, ')
          ..write('zone2Minutes: $zone2Minutes, ')
          ..write('avgHrEstimated: $avgHrEstimated, ')
          ..write('perceivedExertion: $perceivedExertion, ')
          ..write('modality: $modality, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    protocol,
    roundsCompleted,
    roundsTotal,
    totalDurationSeconds,
    zone2Minutes,
    avgHrEstimated,
    perceivedExertion,
    modality,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardioSession &&
          other.id == this.id &&
          other.date == this.date &&
          other.protocol == this.protocol &&
          other.roundsCompleted == this.roundsCompleted &&
          other.roundsTotal == this.roundsTotal &&
          other.totalDurationSeconds == this.totalDurationSeconds &&
          other.zone2Minutes == this.zone2Minutes &&
          other.avgHrEstimated == this.avgHrEstimated &&
          other.perceivedExertion == this.perceivedExertion &&
          other.modality == this.modality &&
          other.notes == this.notes);
}

class CardioSessionsCompanion extends UpdateCompanion<CardioSession> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> protocol;
  final Value<int> roundsCompleted;
  final Value<int> roundsTotal;
  final Value<int> totalDurationSeconds;
  final Value<int> zone2Minutes;
  final Value<int?> avgHrEstimated;
  final Value<int?> perceivedExertion;
  final Value<String> modality;
  final Value<String> notes;
  const CardioSessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.protocol = const Value.absent(),
    this.roundsCompleted = const Value.absent(),
    this.roundsTotal = const Value.absent(),
    this.totalDurationSeconds = const Value.absent(),
    this.zone2Minutes = const Value.absent(),
    this.avgHrEstimated = const Value.absent(),
    this.perceivedExertion = const Value.absent(),
    this.modality = const Value.absent(),
    this.notes = const Value.absent(),
  });
  CardioSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String protocol,
    this.roundsCompleted = const Value.absent(),
    this.roundsTotal = const Value.absent(),
    this.totalDurationSeconds = const Value.absent(),
    this.zone2Minutes = const Value.absent(),
    this.avgHrEstimated = const Value.absent(),
    this.perceivedExertion = const Value.absent(),
    this.modality = const Value.absent(),
    this.notes = const Value.absent(),
  }) : date = Value(date),
       protocol = Value(protocol);
  static Insertable<CardioSession> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? protocol,
    Expression<int>? roundsCompleted,
    Expression<int>? roundsTotal,
    Expression<int>? totalDurationSeconds,
    Expression<int>? zone2Minutes,
    Expression<int>? avgHrEstimated,
    Expression<int>? perceivedExertion,
    Expression<String>? modality,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (protocol != null) 'protocol': protocol,
      if (roundsCompleted != null) 'rounds_completed': roundsCompleted,
      if (roundsTotal != null) 'rounds_total': roundsTotal,
      if (totalDurationSeconds != null)
        'total_duration_seconds': totalDurationSeconds,
      if (zone2Minutes != null) 'zone2_minutes': zone2Minutes,
      if (avgHrEstimated != null) 'avg_hr_estimated': avgHrEstimated,
      if (perceivedExertion != null) 'perceived_exertion': perceivedExertion,
      if (modality != null) 'modality': modality,
      if (notes != null) 'notes': notes,
    });
  }

  CardioSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? protocol,
    Value<int>? roundsCompleted,
    Value<int>? roundsTotal,
    Value<int>? totalDurationSeconds,
    Value<int>? zone2Minutes,
    Value<int?>? avgHrEstimated,
    Value<int?>? perceivedExertion,
    Value<String>? modality,
    Value<String>? notes,
  }) {
    return CardioSessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      protocol: protocol ?? this.protocol,
      roundsCompleted: roundsCompleted ?? this.roundsCompleted,
      roundsTotal: roundsTotal ?? this.roundsTotal,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      zone2Minutes: zone2Minutes ?? this.zone2Minutes,
      avgHrEstimated: avgHrEstimated ?? this.avgHrEstimated,
      perceivedExertion: perceivedExertion ?? this.perceivedExertion,
      modality: modality ?? this.modality,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (protocol.present) {
      map['protocol'] = Variable<String>(protocol.value);
    }
    if (roundsCompleted.present) {
      map['rounds_completed'] = Variable<int>(roundsCompleted.value);
    }
    if (roundsTotal.present) {
      map['rounds_total'] = Variable<int>(roundsTotal.value);
    }
    if (totalDurationSeconds.present) {
      map['total_duration_seconds'] = Variable<int>(totalDurationSeconds.value);
    }
    if (zone2Minutes.present) {
      map['zone2_minutes'] = Variable<int>(zone2Minutes.value);
    }
    if (avgHrEstimated.present) {
      map['avg_hr_estimated'] = Variable<int>(avgHrEstimated.value);
    }
    if (perceivedExertion.present) {
      map['perceived_exertion'] = Variable<int>(perceivedExertion.value);
    }
    if (modality.present) {
      map['modality'] = Variable<String>(modality.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardioSessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('protocol: $protocol, ')
          ..write('roundsCompleted: $roundsCompleted, ')
          ..write('roundsTotal: $roundsTotal, ')
          ..write('totalDurationSeconds: $totalDurationSeconds, ')
          ..write('zone2Minutes: $zone2Minutes, ')
          ..write('avgHrEstimated: $avgHrEstimated, ')
          ..write('perceivedExertion: $perceivedExertion, ')
          ..write('modality: $modality, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $MesocycleStatesTable extends MesocycleStates
    with TableInfo<$MesocycleStatesTable, MesocycleState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MesocycleStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mesocycleNumberMeta = const VerificationMeta(
    'mesocycleNumber',
  );
  @override
  late final GeneratedColumn<int> mesocycleNumber = GeneratedColumn<int>(
    'mesocycle_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _weekInMesocycleMeta = const VerificationMeta(
    'weekInMesocycle',
  );
  @override
  late final GeneratedColumn<int> weekInMesocycle = GeneratedColumn<int>(
    'week_in_mesocycle',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currentBlockMeta = const VerificationMeta(
    'currentBlock',
  );
  @override
  late final GeneratedColumn<String> currentBlock = GeneratedColumn<String>(
    'current_block',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tier,
    mesocycleNumber,
    weekInMesocycle,
    currentBlock,
    startedAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mesocycle_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<MesocycleState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    } else if (isInserting) {
      context.missing(_tierMeta);
    }
    if (data.containsKey('mesocycle_number')) {
      context.handle(
        _mesocycleNumberMeta,
        mesocycleNumber.isAcceptableOrUnknown(
          data['mesocycle_number']!,
          _mesocycleNumberMeta,
        ),
      );
    }
    if (data.containsKey('week_in_mesocycle')) {
      context.handle(
        _weekInMesocycleMeta,
        weekInMesocycle.isAcceptableOrUnknown(
          data['week_in_mesocycle']!,
          _weekInMesocycleMeta,
        ),
      );
    }
    if (data.containsKey('current_block')) {
      context.handle(
        _currentBlockMeta,
        currentBlock.isAcceptableOrUnknown(
          data['current_block']!,
          _currentBlockMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MesocycleState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MesocycleState(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      tier:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}tier'],
          )!,
      mesocycleNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}mesocycle_number'],
          )!,
      weekInMesocycle:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}week_in_mesocycle'],
          )!,
      currentBlock: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_block'],
      ),
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}started_at'],
          )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $MesocycleStatesTable createAlias(String alias) {
    return $MesocycleStatesTable(attachedDatabase, alias);
  }
}

class MesocycleState extends DataClass implements Insertable<MesocycleState> {
  final int id;
  final String tier;
  final int mesocycleNumber;
  final int weekInMesocycle;
  final String? currentBlock;
  final DateTime startedAt;
  final DateTime? completedAt;
  const MesocycleState({
    required this.id,
    required this.tier,
    required this.mesocycleNumber,
    required this.weekInMesocycle,
    this.currentBlock,
    required this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tier'] = Variable<String>(tier);
    map['mesocycle_number'] = Variable<int>(mesocycleNumber);
    map['week_in_mesocycle'] = Variable<int>(weekInMesocycle);
    if (!nullToAbsent || currentBlock != null) {
      map['current_block'] = Variable<String>(currentBlock);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  MesocycleStatesCompanion toCompanion(bool nullToAbsent) {
    return MesocycleStatesCompanion(
      id: Value(id),
      tier: Value(tier),
      mesocycleNumber: Value(mesocycleNumber),
      weekInMesocycle: Value(weekInMesocycle),
      currentBlock:
          currentBlock == null && nullToAbsent
              ? const Value.absent()
              : Value(currentBlock),
      startedAt: Value(startedAt),
      completedAt:
          completedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(completedAt),
    );
  }

  factory MesocycleState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MesocycleState(
      id: serializer.fromJson<int>(json['id']),
      tier: serializer.fromJson<String>(json['tier']),
      mesocycleNumber: serializer.fromJson<int>(json['mesocycleNumber']),
      weekInMesocycle: serializer.fromJson<int>(json['weekInMesocycle']),
      currentBlock: serializer.fromJson<String?>(json['currentBlock']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tier': serializer.toJson<String>(tier),
      'mesocycleNumber': serializer.toJson<int>(mesocycleNumber),
      'weekInMesocycle': serializer.toJson<int>(weekInMesocycle),
      'currentBlock': serializer.toJson<String?>(currentBlock),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  MesocycleState copyWith({
    int? id,
    String? tier,
    int? mesocycleNumber,
    int? weekInMesocycle,
    Value<String?> currentBlock = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => MesocycleState(
    id: id ?? this.id,
    tier: tier ?? this.tier,
    mesocycleNumber: mesocycleNumber ?? this.mesocycleNumber,
    weekInMesocycle: weekInMesocycle ?? this.weekInMesocycle,
    currentBlock: currentBlock.present ? currentBlock.value : this.currentBlock,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  MesocycleState copyWithCompanion(MesocycleStatesCompanion data) {
    return MesocycleState(
      id: data.id.present ? data.id.value : this.id,
      tier: data.tier.present ? data.tier.value : this.tier,
      mesocycleNumber:
          data.mesocycleNumber.present
              ? data.mesocycleNumber.value
              : this.mesocycleNumber,
      weekInMesocycle:
          data.weekInMesocycle.present
              ? data.weekInMesocycle.value
              : this.weekInMesocycle,
      currentBlock:
          data.currentBlock.present
              ? data.currentBlock.value
              : this.currentBlock,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MesocycleState(')
          ..write('id: $id, ')
          ..write('tier: $tier, ')
          ..write('mesocycleNumber: $mesocycleNumber, ')
          ..write('weekInMesocycle: $weekInMesocycle, ')
          ..write('currentBlock: $currentBlock, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tier,
    mesocycleNumber,
    weekInMesocycle,
    currentBlock,
    startedAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MesocycleState &&
          other.id == this.id &&
          other.tier == this.tier &&
          other.mesocycleNumber == this.mesocycleNumber &&
          other.weekInMesocycle == this.weekInMesocycle &&
          other.currentBlock == this.currentBlock &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class MesocycleStatesCompanion extends UpdateCompanion<MesocycleState> {
  final Value<int> id;
  final Value<String> tier;
  final Value<int> mesocycleNumber;
  final Value<int> weekInMesocycle;
  final Value<String?> currentBlock;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  const MesocycleStatesCompanion({
    this.id = const Value.absent(),
    this.tier = const Value.absent(),
    this.mesocycleNumber = const Value.absent(),
    this.weekInMesocycle = const Value.absent(),
    this.currentBlock = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  MesocycleStatesCompanion.insert({
    this.id = const Value.absent(),
    required String tier,
    this.mesocycleNumber = const Value.absent(),
    this.weekInMesocycle = const Value.absent(),
    this.currentBlock = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
  }) : tier = Value(tier),
       startedAt = Value(startedAt);
  static Insertable<MesocycleState> custom({
    Expression<int>? id,
    Expression<String>? tier,
    Expression<int>? mesocycleNumber,
    Expression<int>? weekInMesocycle,
    Expression<String>? currentBlock,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tier != null) 'tier': tier,
      if (mesocycleNumber != null) 'mesocycle_number': mesocycleNumber,
      if (weekInMesocycle != null) 'week_in_mesocycle': weekInMesocycle,
      if (currentBlock != null) 'current_block': currentBlock,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  MesocycleStatesCompanion copyWith({
    Value<int>? id,
    Value<String>? tier,
    Value<int>? mesocycleNumber,
    Value<int>? weekInMesocycle,
    Value<String?>? currentBlock,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
  }) {
    return MesocycleStatesCompanion(
      id: id ?? this.id,
      tier: tier ?? this.tier,
      mesocycleNumber: mesocycleNumber ?? this.mesocycleNumber,
      weekInMesocycle: weekInMesocycle ?? this.weekInMesocycle,
      currentBlock: currentBlock ?? this.currentBlock,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (mesocycleNumber.present) {
      map['mesocycle_number'] = Variable<int>(mesocycleNumber.value);
    }
    if (weekInMesocycle.present) {
      map['week_in_mesocycle'] = Variable<int>(weekInMesocycle.value);
    }
    if (currentBlock.present) {
      map['current_block'] = Variable<String>(currentBlock.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MesocycleStatesCompanion(')
          ..write('id: $id, ')
          ..write('tier: $tier, ')
          ..write('mesocycleNumber: $mesocycleNumber, ')
          ..write('weekInMesocycle: $weekInMesocycle, ')
          ..write('currentBlock: $currentBlock, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $MesocycleExercisesTable extends MesocycleExercises
    with TableInfo<$MesocycleExercisesTable, MesocycleExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MesocycleExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mesocycleNumberMeta = const VerificationMeta(
    'mesocycleNumber',
  );
  @override
  late final GeneratedColumn<int> mesocycleNumber = GeneratedColumn<int>(
    'mesocycle_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotCategoryMeta = const VerificationMeta(
    'slotCategory',
  );
  @override
  late final GeneratedColumn<String> slotCategory = GeneratedColumn<String>(
    'slot_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotTypeMeta = const VerificationMeta(
    'slotType',
  );
  @override
  late final GeneratedColumn<String> slotType = GeneratedColumn<String>(
    'slot_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotIndexMeta = const VerificationMeta(
    'slotIndex',
  );
  @override
  late final GeneratedColumn<int> slotIndex = GeneratedColumn<int>(
    'slot_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _lockedMeta = const VerificationMeta('locked');
  @override
  late final GeneratedColumn<bool> locked = GeneratedColumn<bool>(
    'locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mesocycleNumber,
    slotCategory,
    slotType,
    slotIndex,
    exerciseId,
    locked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mesocycle_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<MesocycleExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mesocycle_number')) {
      context.handle(
        _mesocycleNumberMeta,
        mesocycleNumber.isAcceptableOrUnknown(
          data['mesocycle_number']!,
          _mesocycleNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mesocycleNumberMeta);
    }
    if (data.containsKey('slot_category')) {
      context.handle(
        _slotCategoryMeta,
        slotCategory.isAcceptableOrUnknown(
          data['slot_category']!,
          _slotCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_slotCategoryMeta);
    }
    if (data.containsKey('slot_type')) {
      context.handle(
        _slotTypeMeta,
        slotType.isAcceptableOrUnknown(data['slot_type']!, _slotTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_slotTypeMeta);
    }
    if (data.containsKey('slot_index')) {
      context.handle(
        _slotIndexMeta,
        slotIndex.isAcceptableOrUnknown(data['slot_index']!, _slotIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_slotIndexMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('locked')) {
      context.handle(
        _lockedMeta,
        locked.isAcceptableOrUnknown(data['locked']!, _lockedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MesocycleExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MesocycleExercise(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      mesocycleNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}mesocycle_number'],
          )!,
      slotCategory:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}slot_category'],
          )!,
      slotType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}slot_type'],
          )!,
      slotIndex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}slot_index'],
          )!,
      exerciseId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}exercise_id'],
          )!,
      locked:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}locked'],
          )!,
    );
  }

  @override
  $MesocycleExercisesTable createAlias(String alias) {
    return $MesocycleExercisesTable(attachedDatabase, alias);
  }
}

class MesocycleExercise extends DataClass
    implements Insertable<MesocycleExercise> {
  final int id;
  final int mesocycleNumber;
  final String slotCategory;
  final String slotType;
  final int slotIndex;
  final int exerciseId;
  final bool locked;
  const MesocycleExercise({
    required this.id,
    required this.mesocycleNumber,
    required this.slotCategory,
    required this.slotType,
    required this.slotIndex,
    required this.exerciseId,
    required this.locked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mesocycle_number'] = Variable<int>(mesocycleNumber);
    map['slot_category'] = Variable<String>(slotCategory);
    map['slot_type'] = Variable<String>(slotType);
    map['slot_index'] = Variable<int>(slotIndex);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['locked'] = Variable<bool>(locked);
    return map;
  }

  MesocycleExercisesCompanion toCompanion(bool nullToAbsent) {
    return MesocycleExercisesCompanion(
      id: Value(id),
      mesocycleNumber: Value(mesocycleNumber),
      slotCategory: Value(slotCategory),
      slotType: Value(slotType),
      slotIndex: Value(slotIndex),
      exerciseId: Value(exerciseId),
      locked: Value(locked),
    );
  }

  factory MesocycleExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MesocycleExercise(
      id: serializer.fromJson<int>(json['id']),
      mesocycleNumber: serializer.fromJson<int>(json['mesocycleNumber']),
      slotCategory: serializer.fromJson<String>(json['slotCategory']),
      slotType: serializer.fromJson<String>(json['slotType']),
      slotIndex: serializer.fromJson<int>(json['slotIndex']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      locked: serializer.fromJson<bool>(json['locked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mesocycleNumber': serializer.toJson<int>(mesocycleNumber),
      'slotCategory': serializer.toJson<String>(slotCategory),
      'slotType': serializer.toJson<String>(slotType),
      'slotIndex': serializer.toJson<int>(slotIndex),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'locked': serializer.toJson<bool>(locked),
    };
  }

  MesocycleExercise copyWith({
    int? id,
    int? mesocycleNumber,
    String? slotCategory,
    String? slotType,
    int? slotIndex,
    int? exerciseId,
    bool? locked,
  }) => MesocycleExercise(
    id: id ?? this.id,
    mesocycleNumber: mesocycleNumber ?? this.mesocycleNumber,
    slotCategory: slotCategory ?? this.slotCategory,
    slotType: slotType ?? this.slotType,
    slotIndex: slotIndex ?? this.slotIndex,
    exerciseId: exerciseId ?? this.exerciseId,
    locked: locked ?? this.locked,
  );
  MesocycleExercise copyWithCompanion(MesocycleExercisesCompanion data) {
    return MesocycleExercise(
      id: data.id.present ? data.id.value : this.id,
      mesocycleNumber:
          data.mesocycleNumber.present
              ? data.mesocycleNumber.value
              : this.mesocycleNumber,
      slotCategory:
          data.slotCategory.present
              ? data.slotCategory.value
              : this.slotCategory,
      slotType: data.slotType.present ? data.slotType.value : this.slotType,
      slotIndex: data.slotIndex.present ? data.slotIndex.value : this.slotIndex,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      locked: data.locked.present ? data.locked.value : this.locked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MesocycleExercise(')
          ..write('id: $id, ')
          ..write('mesocycleNumber: $mesocycleNumber, ')
          ..write('slotCategory: $slotCategory, ')
          ..write('slotType: $slotType, ')
          ..write('slotIndex: $slotIndex, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('locked: $locked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mesocycleNumber,
    slotCategory,
    slotType,
    slotIndex,
    exerciseId,
    locked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MesocycleExercise &&
          other.id == this.id &&
          other.mesocycleNumber == this.mesocycleNumber &&
          other.slotCategory == this.slotCategory &&
          other.slotType == this.slotType &&
          other.slotIndex == this.slotIndex &&
          other.exerciseId == this.exerciseId &&
          other.locked == this.locked);
}

class MesocycleExercisesCompanion extends UpdateCompanion<MesocycleExercise> {
  final Value<int> id;
  final Value<int> mesocycleNumber;
  final Value<String> slotCategory;
  final Value<String> slotType;
  final Value<int> slotIndex;
  final Value<int> exerciseId;
  final Value<bool> locked;
  const MesocycleExercisesCompanion({
    this.id = const Value.absent(),
    this.mesocycleNumber = const Value.absent(),
    this.slotCategory = const Value.absent(),
    this.slotType = const Value.absent(),
    this.slotIndex = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.locked = const Value.absent(),
  });
  MesocycleExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int mesocycleNumber,
    required String slotCategory,
    required String slotType,
    required int slotIndex,
    required int exerciseId,
    this.locked = const Value.absent(),
  }) : mesocycleNumber = Value(mesocycleNumber),
       slotCategory = Value(slotCategory),
       slotType = Value(slotType),
       slotIndex = Value(slotIndex),
       exerciseId = Value(exerciseId);
  static Insertable<MesocycleExercise> custom({
    Expression<int>? id,
    Expression<int>? mesocycleNumber,
    Expression<String>? slotCategory,
    Expression<String>? slotType,
    Expression<int>? slotIndex,
    Expression<int>? exerciseId,
    Expression<bool>? locked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mesocycleNumber != null) 'mesocycle_number': mesocycleNumber,
      if (slotCategory != null) 'slot_category': slotCategory,
      if (slotType != null) 'slot_type': slotType,
      if (slotIndex != null) 'slot_index': slotIndex,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (locked != null) 'locked': locked,
    });
  }

  MesocycleExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? mesocycleNumber,
    Value<String>? slotCategory,
    Value<String>? slotType,
    Value<int>? slotIndex,
    Value<int>? exerciseId,
    Value<bool>? locked,
  }) {
    return MesocycleExercisesCompanion(
      id: id ?? this.id,
      mesocycleNumber: mesocycleNumber ?? this.mesocycleNumber,
      slotCategory: slotCategory ?? this.slotCategory,
      slotType: slotType ?? this.slotType,
      slotIndex: slotIndex ?? this.slotIndex,
      exerciseId: exerciseId ?? this.exerciseId,
      locked: locked ?? this.locked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mesocycleNumber.present) {
      map['mesocycle_number'] = Variable<int>(mesocycleNumber.value);
    }
    if (slotCategory.present) {
      map['slot_category'] = Variable<String>(slotCategory.value);
    }
    if (slotType.present) {
      map['slot_type'] = Variable<String>(slotType.value);
    }
    if (slotIndex.present) {
      map['slot_index'] = Variable<int>(slotIndex.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (locked.present) {
      map['locked'] = Variable<bool>(locked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MesocycleExercisesCompanion(')
          ..write('id: $id, ')
          ..write('mesocycleNumber: $mesocycleNumber, ')
          ..write('slotCategory: $slotCategory, ')
          ..write('slotType: $slotType, ')
          ..write('slotIndex: $slotIndex, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('locked: $locked')
          ..write(')'))
        .toString();
  }
}

class $HrvReadingsTable extends HrvReadings
    with TableInfo<$HrvReadingsTable, HrvReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HrvReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rmssdMeta = const VerificationMeta('rmssd');
  @override
  late final GeneratedColumn<double> rmssd = GeneratedColumn<double>(
    'rmssd',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lnRmssdMeta = const VerificationMeta(
    'lnRmssd',
  );
  @override
  late final GeneratedColumn<double> lnRmssd = GeneratedColumn<double>(
    'ln_rmssd',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stressIndexMeta = const VerificationMeta(
    'stressIndex',
  );
  @override
  late final GeneratedColumn<double> stressIndex = GeneratedColumn<double>(
    'stress_index',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextMeta = const VerificationMeta(
    'context',
  );
  @override
  late final GeneratedColumn<String> context = GeneratedColumn<String>(
    'context',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('morning'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    rmssd,
    lnRmssd,
    stressIndex,
    source,
    context,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hrv_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<HrvReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('rmssd')) {
      context.handle(
        _rmssdMeta,
        rmssd.isAcceptableOrUnknown(data['rmssd']!, _rmssdMeta),
      );
    } else if (isInserting) {
      context.missing(_rmssdMeta);
    }
    if (data.containsKey('ln_rmssd')) {
      context.handle(
        _lnRmssdMeta,
        lnRmssd.isAcceptableOrUnknown(data['ln_rmssd']!, _lnRmssdMeta),
      );
    } else if (isInserting) {
      context.missing(_lnRmssdMeta);
    }
    if (data.containsKey('stress_index')) {
      context.handle(
        _stressIndexMeta,
        stressIndex.isAcceptableOrUnknown(
          data['stress_index']!,
          _stressIndexMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('context')) {
      context.handle(
        _contextMeta,
        this.context.isAcceptableOrUnknown(data['context']!, _contextMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HrvReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HrvReading(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      rmssd:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}rmssd'],
          )!,
      lnRmssd:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}ln_rmssd'],
          )!,
      stressIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stress_index'],
      ),
      source:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source'],
          )!,
      context:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}context'],
          )!,
    );
  }

  @override
  $HrvReadingsTable createAlias(String alias) {
    return $HrvReadingsTable(attachedDatabase, alias);
  }
}

class HrvReading extends DataClass implements Insertable<HrvReading> {
  final int id;
  final DateTime timestamp;
  final double rmssd;
  final double lnRmssd;
  final double? stressIndex;
  final String source;
  final String context;
  const HrvReading({
    required this.id,
    required this.timestamp,
    required this.rmssd,
    required this.lnRmssd,
    this.stressIndex,
    required this.source,
    required this.context,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['rmssd'] = Variable<double>(rmssd);
    map['ln_rmssd'] = Variable<double>(lnRmssd);
    if (!nullToAbsent || stressIndex != null) {
      map['stress_index'] = Variable<double>(stressIndex);
    }
    map['source'] = Variable<String>(source);
    map['context'] = Variable<String>(context);
    return map;
  }

  HrvReadingsCompanion toCompanion(bool nullToAbsent) {
    return HrvReadingsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      rmssd: Value(rmssd),
      lnRmssd: Value(lnRmssd),
      stressIndex:
          stressIndex == null && nullToAbsent
              ? const Value.absent()
              : Value(stressIndex),
      source: Value(source),
      context: Value(context),
    );
  }

  factory HrvReading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HrvReading(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      rmssd: serializer.fromJson<double>(json['rmssd']),
      lnRmssd: serializer.fromJson<double>(json['lnRmssd']),
      stressIndex: serializer.fromJson<double?>(json['stressIndex']),
      source: serializer.fromJson<String>(json['source']),
      context: serializer.fromJson<String>(json['context']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'rmssd': serializer.toJson<double>(rmssd),
      'lnRmssd': serializer.toJson<double>(lnRmssd),
      'stressIndex': serializer.toJson<double?>(stressIndex),
      'source': serializer.toJson<String>(source),
      'context': serializer.toJson<String>(context),
    };
  }

  HrvReading copyWith({
    int? id,
    DateTime? timestamp,
    double? rmssd,
    double? lnRmssd,
    Value<double?> stressIndex = const Value.absent(),
    String? source,
    String? context,
  }) => HrvReading(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    rmssd: rmssd ?? this.rmssd,
    lnRmssd: lnRmssd ?? this.lnRmssd,
    stressIndex: stressIndex.present ? stressIndex.value : this.stressIndex,
    source: source ?? this.source,
    context: context ?? this.context,
  );
  HrvReading copyWithCompanion(HrvReadingsCompanion data) {
    return HrvReading(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      rmssd: data.rmssd.present ? data.rmssd.value : this.rmssd,
      lnRmssd: data.lnRmssd.present ? data.lnRmssd.value : this.lnRmssd,
      stressIndex:
          data.stressIndex.present ? data.stressIndex.value : this.stressIndex,
      source: data.source.present ? data.source.value : this.source,
      context: data.context.present ? data.context.value : this.context,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HrvReading(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('rmssd: $rmssd, ')
          ..write('lnRmssd: $lnRmssd, ')
          ..write('stressIndex: $stressIndex, ')
          ..write('source: $source, ')
          ..write('context: $context')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, timestamp, rmssd, lnRmssd, stressIndex, source, context);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HrvReading &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.rmssd == this.rmssd &&
          other.lnRmssd == this.lnRmssd &&
          other.stressIndex == this.stressIndex &&
          other.source == this.source &&
          other.context == this.context);
}

class HrvReadingsCompanion extends UpdateCompanion<HrvReading> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<double> rmssd;
  final Value<double> lnRmssd;
  final Value<double?> stressIndex;
  final Value<String> source;
  final Value<String> context;
  const HrvReadingsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rmssd = const Value.absent(),
    this.lnRmssd = const Value.absent(),
    this.stressIndex = const Value.absent(),
    this.source = const Value.absent(),
    this.context = const Value.absent(),
  });
  HrvReadingsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required double rmssd,
    required double lnRmssd,
    this.stressIndex = const Value.absent(),
    required String source,
    this.context = const Value.absent(),
  }) : timestamp = Value(timestamp),
       rmssd = Value(rmssd),
       lnRmssd = Value(lnRmssd),
       source = Value(source);
  static Insertable<HrvReading> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<double>? rmssd,
    Expression<double>? lnRmssd,
    Expression<double>? stressIndex,
    Expression<String>? source,
    Expression<String>? context,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (rmssd != null) 'rmssd': rmssd,
      if (lnRmssd != null) 'ln_rmssd': lnRmssd,
      if (stressIndex != null) 'stress_index': stressIndex,
      if (source != null) 'source': source,
      if (context != null) 'context': context,
    });
  }

  HrvReadingsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<double>? rmssd,
    Value<double>? lnRmssd,
    Value<double?>? stressIndex,
    Value<String>? source,
    Value<String>? context,
  }) {
    return HrvReadingsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      rmssd: rmssd ?? this.rmssd,
      lnRmssd: lnRmssd ?? this.lnRmssd,
      stressIndex: stressIndex ?? this.stressIndex,
      source: source ?? this.source,
      context: context ?? this.context,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rmssd.present) {
      map['rmssd'] = Variable<double>(rmssd.value);
    }
    if (lnRmssd.present) {
      map['ln_rmssd'] = Variable<double>(lnRmssd.value);
    }
    if (stressIndex.present) {
      map['stress_index'] = Variable<double>(stressIndex.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (context.present) {
      map['context'] = Variable<String>(context.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HrvReadingsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('rmssd: $rmssd, ')
          ..write('lnRmssd: $lnRmssd, ')
          ..write('stressIndex: $stressIndex, ')
          ..write('source: $source, ')
          ..write('context: $context')
          ..write(')'))
        .toString();
  }
}

class $Week0SessionsTable extends Week0Sessions
    with TableInfo<$Week0SessionsTable, Week0Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $Week0SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionNumberMeta = const VerificationMeta(
    'sessionNumber',
  );
  @override
  late final GeneratedColumn<int> sessionNumber = GeneratedColumn<int>(
    'session_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusMeta = const VerificationMeta('focus');
  @override
  late final GeneratedColumn<String> focus = GeneratedColumn<String>(
    'focus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgRpeMeta = const VerificationMeta('avgRpe');
  @override
  late final GeneratedColumn<double> avgRpe = GeneratedColumn<double>(
    'avg_rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passedMeta = const VerificationMeta('passed');
  @override
  late final GeneratedColumn<bool> passed = GeneratedColumn<bool>(
    'passed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("passed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionNumber,
    focus,
    completedAt,
    avgRpe,
    passed,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'week0_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Week0Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_number')) {
      context.handle(
        _sessionNumberMeta,
        sessionNumber.isAcceptableOrUnknown(
          data['session_number']!,
          _sessionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionNumberMeta);
    }
    if (data.containsKey('focus')) {
      context.handle(
        _focusMeta,
        focus.isAcceptableOrUnknown(data['focus']!, _focusMeta),
      );
    } else if (isInserting) {
      context.missing(_focusMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('avg_rpe')) {
      context.handle(
        _avgRpeMeta,
        avgRpe.isAcceptableOrUnknown(data['avg_rpe']!, _avgRpeMeta),
      );
    }
    if (data.containsKey('passed')) {
      context.handle(
        _passedMeta,
        passed.isAcceptableOrUnknown(data['passed']!, _passedMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Week0Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Week0Session(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sessionNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}session_number'],
          )!,
      focus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}focus'],
          )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      avgRpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_rpe'],
      ),
      passed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}passed'],
          )!,
      notes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notes'],
          )!,
    );
  }

  @override
  $Week0SessionsTable createAlias(String alias) {
    return $Week0SessionsTable(attachedDatabase, alias);
  }
}

class Week0Session extends DataClass implements Insertable<Week0Session> {
  final int id;
  final int sessionNumber;
  final String focus;
  final DateTime? completedAt;
  final double? avgRpe;
  final bool passed;
  final String notes;
  const Week0Session({
    required this.id,
    required this.sessionNumber,
    required this.focus,
    this.completedAt,
    this.avgRpe,
    required this.passed,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_number'] = Variable<int>(sessionNumber);
    map['focus'] = Variable<String>(focus);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || avgRpe != null) {
      map['avg_rpe'] = Variable<double>(avgRpe);
    }
    map['passed'] = Variable<bool>(passed);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  Week0SessionsCompanion toCompanion(bool nullToAbsent) {
    return Week0SessionsCompanion(
      id: Value(id),
      sessionNumber: Value(sessionNumber),
      focus: Value(focus),
      completedAt:
          completedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(completedAt),
      avgRpe:
          avgRpe == null && nullToAbsent ? const Value.absent() : Value(avgRpe),
      passed: Value(passed),
      notes: Value(notes),
    );
  }

  factory Week0Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Week0Session(
      id: serializer.fromJson<int>(json['id']),
      sessionNumber: serializer.fromJson<int>(json['sessionNumber']),
      focus: serializer.fromJson<String>(json['focus']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      avgRpe: serializer.fromJson<double?>(json['avgRpe']),
      passed: serializer.fromJson<bool>(json['passed']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionNumber': serializer.toJson<int>(sessionNumber),
      'focus': serializer.toJson<String>(focus),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'avgRpe': serializer.toJson<double?>(avgRpe),
      'passed': serializer.toJson<bool>(passed),
      'notes': serializer.toJson<String>(notes),
    };
  }

  Week0Session copyWith({
    int? id,
    int? sessionNumber,
    String? focus,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<double?> avgRpe = const Value.absent(),
    bool? passed,
    String? notes,
  }) => Week0Session(
    id: id ?? this.id,
    sessionNumber: sessionNumber ?? this.sessionNumber,
    focus: focus ?? this.focus,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    avgRpe: avgRpe.present ? avgRpe.value : this.avgRpe,
    passed: passed ?? this.passed,
    notes: notes ?? this.notes,
  );
  Week0Session copyWithCompanion(Week0SessionsCompanion data) {
    return Week0Session(
      id: data.id.present ? data.id.value : this.id,
      sessionNumber:
          data.sessionNumber.present
              ? data.sessionNumber.value
              : this.sessionNumber,
      focus: data.focus.present ? data.focus.value : this.focus,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      avgRpe: data.avgRpe.present ? data.avgRpe.value : this.avgRpe,
      passed: data.passed.present ? data.passed.value : this.passed,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Week0Session(')
          ..write('id: $id, ')
          ..write('sessionNumber: $sessionNumber, ')
          ..write('focus: $focus, ')
          ..write('completedAt: $completedAt, ')
          ..write('avgRpe: $avgRpe, ')
          ..write('passed: $passed, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionNumber, focus, completedAt, avgRpe, passed, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Week0Session &&
          other.id == this.id &&
          other.sessionNumber == this.sessionNumber &&
          other.focus == this.focus &&
          other.completedAt == this.completedAt &&
          other.avgRpe == this.avgRpe &&
          other.passed == this.passed &&
          other.notes == this.notes);
}

class Week0SessionsCompanion extends UpdateCompanion<Week0Session> {
  final Value<int> id;
  final Value<int> sessionNumber;
  final Value<String> focus;
  final Value<DateTime?> completedAt;
  final Value<double?> avgRpe;
  final Value<bool> passed;
  final Value<String> notes;
  const Week0SessionsCompanion({
    this.id = const Value.absent(),
    this.sessionNumber = const Value.absent(),
    this.focus = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.avgRpe = const Value.absent(),
    this.passed = const Value.absent(),
    this.notes = const Value.absent(),
  });
  Week0SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionNumber,
    required String focus,
    this.completedAt = const Value.absent(),
    this.avgRpe = const Value.absent(),
    this.passed = const Value.absent(),
    this.notes = const Value.absent(),
  }) : sessionNumber = Value(sessionNumber),
       focus = Value(focus);
  static Insertable<Week0Session> custom({
    Expression<int>? id,
    Expression<int>? sessionNumber,
    Expression<String>? focus,
    Expression<DateTime>? completedAt,
    Expression<double>? avgRpe,
    Expression<bool>? passed,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionNumber != null) 'session_number': sessionNumber,
      if (focus != null) 'focus': focus,
      if (completedAt != null) 'completed_at': completedAt,
      if (avgRpe != null) 'avg_rpe': avgRpe,
      if (passed != null) 'passed': passed,
      if (notes != null) 'notes': notes,
    });
  }

  Week0SessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionNumber,
    Value<String>? focus,
    Value<DateTime?>? completedAt,
    Value<double?>? avgRpe,
    Value<bool>? passed,
    Value<String>? notes,
  }) {
    return Week0SessionsCompanion(
      id: id ?? this.id,
      sessionNumber: sessionNumber ?? this.sessionNumber,
      focus: focus ?? this.focus,
      completedAt: completedAt ?? this.completedAt,
      avgRpe: avgRpe ?? this.avgRpe,
      passed: passed ?? this.passed,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionNumber.present) {
      map['session_number'] = Variable<int>(sessionNumber.value);
    }
    if (focus.present) {
      map['focus'] = Variable<String>(focus.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (avgRpe.present) {
      map['avg_rpe'] = Variable<double>(avgRpe.value);
    }
    if (passed.present) {
      map['passed'] = Variable<bool>(passed.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('Week0SessionsCompanion(')
          ..write('id: $id, ')
          ..write('sessionNumber: $sessionNumber, ')
          ..write('focus: $focus, ')
          ..write('completedAt: $completedAt, ')
          ..write('avgRpe: $avgRpe, ')
          ..write('passed: $passed, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $RingDevicesTable extends RingDevices
    with TableInfo<$RingDevicesTable, RingDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RingDevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _macAddressMeta = const VerificationMeta(
    'macAddress',
  );
  @override
  late final GeneratedColumn<String> macAddress = GeneratedColumn<String>(
    'mac_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firmwareVersionMeta = const VerificationMeta(
    'firmwareVersion',
  );
  @override
  late final GeneratedColumn<String> firmwareVersion = GeneratedColumn<String>(
    'firmware_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _hardwareVersionMeta = const VerificationMeta(
    'hardwareVersion',
  );
  @override
  late final GeneratedColumn<String> hardwareVersion = GeneratedColumn<String>(
    'hardware_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _capabilitiesJsonMeta = const VerificationMeta(
    'capabilitiesJson',
  );
  @override
  late final GeneratedColumn<String> capabilitiesJson = GeneratedColumn<String>(
    'capabilities_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _lastSyncMeta = const VerificationMeta(
    'lastSync',
  );
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
    'last_sync',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batteryLevelMeta = const VerificationMeta(
    'batteryLevel',
  );
  @override
  late final GeneratedColumn<int> batteryLevel = GeneratedColumn<int>(
    'battery_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _pairedAtMeta = const VerificationMeta(
    'pairedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pairedAt = GeneratedColumn<DateTime>(
    'paired_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    macAddress,
    name,
    firmwareVersion,
    hardwareVersion,
    capabilitiesJson,
    lastSync,
    batteryLevel,
    pairedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ring_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<RingDevice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mac_address')) {
      context.handle(
        _macAddressMeta,
        macAddress.isAcceptableOrUnknown(data['mac_address']!, _macAddressMeta),
      );
    } else if (isInserting) {
      context.missing(_macAddressMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('firmware_version')) {
      context.handle(
        _firmwareVersionMeta,
        firmwareVersion.isAcceptableOrUnknown(
          data['firmware_version']!,
          _firmwareVersionMeta,
        ),
      );
    }
    if (data.containsKey('hardware_version')) {
      context.handle(
        _hardwareVersionMeta,
        hardwareVersion.isAcceptableOrUnknown(
          data['hardware_version']!,
          _hardwareVersionMeta,
        ),
      );
    }
    if (data.containsKey('capabilities_json')) {
      context.handle(
        _capabilitiesJsonMeta,
        capabilitiesJson.isAcceptableOrUnknown(
          data['capabilities_json']!,
          _capabilitiesJsonMeta,
        ),
      );
    }
    if (data.containsKey('last_sync')) {
      context.handle(
        _lastSyncMeta,
        lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta),
      );
    }
    if (data.containsKey('battery_level')) {
      context.handle(
        _batteryLevelMeta,
        batteryLevel.isAcceptableOrUnknown(
          data['battery_level']!,
          _batteryLevelMeta,
        ),
      );
    }
    if (data.containsKey('paired_at')) {
      context.handle(
        _pairedAtMeta,
        pairedAt.isAcceptableOrUnknown(data['paired_at']!, _pairedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_pairedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RingDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RingDevice(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      macAddress:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}mac_address'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      firmwareVersion:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}firmware_version'],
          )!,
      hardwareVersion:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}hardware_version'],
          )!,
      capabilitiesJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}capabilities_json'],
          )!,
      lastSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync'],
      ),
      batteryLevel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}battery_level'],
          )!,
      pairedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}paired_at'],
          )!,
    );
  }

  @override
  $RingDevicesTable createAlias(String alias) {
    return $RingDevicesTable(attachedDatabase, alias);
  }
}

class RingDevice extends DataClass implements Insertable<RingDevice> {
  final int id;
  final String macAddress;
  final String name;
  final String firmwareVersion;
  final String hardwareVersion;
  final String capabilitiesJson;
  final DateTime? lastSync;
  final int batteryLevel;
  final DateTime pairedAt;
  const RingDevice({
    required this.id,
    required this.macAddress,
    required this.name,
    required this.firmwareVersion,
    required this.hardwareVersion,
    required this.capabilitiesJson,
    this.lastSync,
    required this.batteryLevel,
    required this.pairedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mac_address'] = Variable<String>(macAddress);
    map['name'] = Variable<String>(name);
    map['firmware_version'] = Variable<String>(firmwareVersion);
    map['hardware_version'] = Variable<String>(hardwareVersion);
    map['capabilities_json'] = Variable<String>(capabilitiesJson);
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    map['battery_level'] = Variable<int>(batteryLevel);
    map['paired_at'] = Variable<DateTime>(pairedAt);
    return map;
  }

  RingDevicesCompanion toCompanion(bool nullToAbsent) {
    return RingDevicesCompanion(
      id: Value(id),
      macAddress: Value(macAddress),
      name: Value(name),
      firmwareVersion: Value(firmwareVersion),
      hardwareVersion: Value(hardwareVersion),
      capabilitiesJson: Value(capabilitiesJson),
      lastSync:
          lastSync == null && nullToAbsent
              ? const Value.absent()
              : Value(lastSync),
      batteryLevel: Value(batteryLevel),
      pairedAt: Value(pairedAt),
    );
  }

  factory RingDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RingDevice(
      id: serializer.fromJson<int>(json['id']),
      macAddress: serializer.fromJson<String>(json['macAddress']),
      name: serializer.fromJson<String>(json['name']),
      firmwareVersion: serializer.fromJson<String>(json['firmwareVersion']),
      hardwareVersion: serializer.fromJson<String>(json['hardwareVersion']),
      capabilitiesJson: serializer.fromJson<String>(json['capabilitiesJson']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
      batteryLevel: serializer.fromJson<int>(json['batteryLevel']),
      pairedAt: serializer.fromJson<DateTime>(json['pairedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'macAddress': serializer.toJson<String>(macAddress),
      'name': serializer.toJson<String>(name),
      'firmwareVersion': serializer.toJson<String>(firmwareVersion),
      'hardwareVersion': serializer.toJson<String>(hardwareVersion),
      'capabilitiesJson': serializer.toJson<String>(capabilitiesJson),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
      'batteryLevel': serializer.toJson<int>(batteryLevel),
      'pairedAt': serializer.toJson<DateTime>(pairedAt),
    };
  }

  RingDevice copyWith({
    int? id,
    String? macAddress,
    String? name,
    String? firmwareVersion,
    String? hardwareVersion,
    String? capabilitiesJson,
    Value<DateTime?> lastSync = const Value.absent(),
    int? batteryLevel,
    DateTime? pairedAt,
  }) => RingDevice(
    id: id ?? this.id,
    macAddress: macAddress ?? this.macAddress,
    name: name ?? this.name,
    firmwareVersion: firmwareVersion ?? this.firmwareVersion,
    hardwareVersion: hardwareVersion ?? this.hardwareVersion,
    capabilitiesJson: capabilitiesJson ?? this.capabilitiesJson,
    lastSync: lastSync.present ? lastSync.value : this.lastSync,
    batteryLevel: batteryLevel ?? this.batteryLevel,
    pairedAt: pairedAt ?? this.pairedAt,
  );
  RingDevice copyWithCompanion(RingDevicesCompanion data) {
    return RingDevice(
      id: data.id.present ? data.id.value : this.id,
      macAddress:
          data.macAddress.present ? data.macAddress.value : this.macAddress,
      name: data.name.present ? data.name.value : this.name,
      firmwareVersion:
          data.firmwareVersion.present
              ? data.firmwareVersion.value
              : this.firmwareVersion,
      hardwareVersion:
          data.hardwareVersion.present
              ? data.hardwareVersion.value
              : this.hardwareVersion,
      capabilitiesJson:
          data.capabilitiesJson.present
              ? data.capabilitiesJson.value
              : this.capabilitiesJson,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
      batteryLevel:
          data.batteryLevel.present
              ? data.batteryLevel.value
              : this.batteryLevel,
      pairedAt: data.pairedAt.present ? data.pairedAt.value : this.pairedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RingDevice(')
          ..write('id: $id, ')
          ..write('macAddress: $macAddress, ')
          ..write('name: $name, ')
          ..write('firmwareVersion: $firmwareVersion, ')
          ..write('hardwareVersion: $hardwareVersion, ')
          ..write('capabilitiesJson: $capabilitiesJson, ')
          ..write('lastSync: $lastSync, ')
          ..write('batteryLevel: $batteryLevel, ')
          ..write('pairedAt: $pairedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    macAddress,
    name,
    firmwareVersion,
    hardwareVersion,
    capabilitiesJson,
    lastSync,
    batteryLevel,
    pairedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RingDevice &&
          other.id == this.id &&
          other.macAddress == this.macAddress &&
          other.name == this.name &&
          other.firmwareVersion == this.firmwareVersion &&
          other.hardwareVersion == this.hardwareVersion &&
          other.capabilitiesJson == this.capabilitiesJson &&
          other.lastSync == this.lastSync &&
          other.batteryLevel == this.batteryLevel &&
          other.pairedAt == this.pairedAt);
}

class RingDevicesCompanion extends UpdateCompanion<RingDevice> {
  final Value<int> id;
  final Value<String> macAddress;
  final Value<String> name;
  final Value<String> firmwareVersion;
  final Value<String> hardwareVersion;
  final Value<String> capabilitiesJson;
  final Value<DateTime?> lastSync;
  final Value<int> batteryLevel;
  final Value<DateTime> pairedAt;
  const RingDevicesCompanion({
    this.id = const Value.absent(),
    this.macAddress = const Value.absent(),
    this.name = const Value.absent(),
    this.firmwareVersion = const Value.absent(),
    this.hardwareVersion = const Value.absent(),
    this.capabilitiesJson = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.batteryLevel = const Value.absent(),
    this.pairedAt = const Value.absent(),
  });
  RingDevicesCompanion.insert({
    this.id = const Value.absent(),
    required String macAddress,
    required String name,
    this.firmwareVersion = const Value.absent(),
    this.hardwareVersion = const Value.absent(),
    this.capabilitiesJson = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.batteryLevel = const Value.absent(),
    required DateTime pairedAt,
  }) : macAddress = Value(macAddress),
       name = Value(name),
       pairedAt = Value(pairedAt);
  static Insertable<RingDevice> custom({
    Expression<int>? id,
    Expression<String>? macAddress,
    Expression<String>? name,
    Expression<String>? firmwareVersion,
    Expression<String>? hardwareVersion,
    Expression<String>? capabilitiesJson,
    Expression<DateTime>? lastSync,
    Expression<int>? batteryLevel,
    Expression<DateTime>? pairedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (macAddress != null) 'mac_address': macAddress,
      if (name != null) 'name': name,
      if (firmwareVersion != null) 'firmware_version': firmwareVersion,
      if (hardwareVersion != null) 'hardware_version': hardwareVersion,
      if (capabilitiesJson != null) 'capabilities_json': capabilitiesJson,
      if (lastSync != null) 'last_sync': lastSync,
      if (batteryLevel != null) 'battery_level': batteryLevel,
      if (pairedAt != null) 'paired_at': pairedAt,
    });
  }

  RingDevicesCompanion copyWith({
    Value<int>? id,
    Value<String>? macAddress,
    Value<String>? name,
    Value<String>? firmwareVersion,
    Value<String>? hardwareVersion,
    Value<String>? capabilitiesJson,
    Value<DateTime?>? lastSync,
    Value<int>? batteryLevel,
    Value<DateTime>? pairedAt,
  }) {
    return RingDevicesCompanion(
      id: id ?? this.id,
      macAddress: macAddress ?? this.macAddress,
      name: name ?? this.name,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      hardwareVersion: hardwareVersion ?? this.hardwareVersion,
      capabilitiesJson: capabilitiesJson ?? this.capabilitiesJson,
      lastSync: lastSync ?? this.lastSync,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      pairedAt: pairedAt ?? this.pairedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (macAddress.present) {
      map['mac_address'] = Variable<String>(macAddress.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (firmwareVersion.present) {
      map['firmware_version'] = Variable<String>(firmwareVersion.value);
    }
    if (hardwareVersion.present) {
      map['hardware_version'] = Variable<String>(hardwareVersion.value);
    }
    if (capabilitiesJson.present) {
      map['capabilities_json'] = Variable<String>(capabilitiesJson.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (batteryLevel.present) {
      map['battery_level'] = Variable<int>(batteryLevel.value);
    }
    if (pairedAt.present) {
      map['paired_at'] = Variable<DateTime>(pairedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RingDevicesCompanion(')
          ..write('id: $id, ')
          ..write('macAddress: $macAddress, ')
          ..write('name: $name, ')
          ..write('firmwareVersion: $firmwareVersion, ')
          ..write('hardwareVersion: $hardwareVersion, ')
          ..write('capabilitiesJson: $capabilitiesJson, ')
          ..write('lastSync: $lastSync, ')
          ..write('batteryLevel: $batteryLevel, ')
          ..write('pairedAt: $pairedAt')
          ..write(')'))
        .toString();
  }
}

class $RingHrSamplesTable extends RingHrSamples
    with TableInfo<$RingHrSamplesTable, RingHrSample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RingHrSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hrMeta = const VerificationMeta('hr');
  @override
  late final GeneratedColumn<int> hr = GeneratedColumn<int>(
    'hr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<double> quality = GeneratedColumn<double>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, timestamp, hr, source, quality];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ring_hr_samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<RingHrSample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('hr')) {
      context.handle(_hrMeta, hr.isAcceptableOrUnknown(data['hr']!, _hrMeta));
    } else if (isInserting) {
      context.missing(_hrMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RingHrSample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RingHrSample(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      hr:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}hr'],
          )!,
      source:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}source'],
          )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quality'],
      ),
    );
  }

  @override
  $RingHrSamplesTable createAlias(String alias) {
    return $RingHrSamplesTable(attachedDatabase, alias);
  }
}

class RingHrSample extends DataClass implements Insertable<RingHrSample> {
  final int id;
  final DateTime timestamp;
  final int hr;
  final String source;
  final double? quality;
  const RingHrSample({
    required this.id,
    required this.timestamp,
    required this.hr,
    required this.source,
    this.quality,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['hr'] = Variable<int>(hr);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<double>(quality);
    }
    return map;
  }

  RingHrSamplesCompanion toCompanion(bool nullToAbsent) {
    return RingHrSamplesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      hr: Value(hr),
      source: Value(source),
      quality:
          quality == null && nullToAbsent
              ? const Value.absent()
              : Value(quality),
    );
  }

  factory RingHrSample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RingHrSample(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      hr: serializer.fromJson<int>(json['hr']),
      source: serializer.fromJson<String>(json['source']),
      quality: serializer.fromJson<double?>(json['quality']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'hr': serializer.toJson<int>(hr),
      'source': serializer.toJson<String>(source),
      'quality': serializer.toJson<double?>(quality),
    };
  }

  RingHrSample copyWith({
    int? id,
    DateTime? timestamp,
    int? hr,
    String? source,
    Value<double?> quality = const Value.absent(),
  }) => RingHrSample(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    hr: hr ?? this.hr,
    source: source ?? this.source,
    quality: quality.present ? quality.value : this.quality,
  );
  RingHrSample copyWithCompanion(RingHrSamplesCompanion data) {
    return RingHrSample(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      hr: data.hr.present ? data.hr.value : this.hr,
      source: data.source.present ? data.source.value : this.source,
      quality: data.quality.present ? data.quality.value : this.quality,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RingHrSample(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('hr: $hr, ')
          ..write('source: $source, ')
          ..write('quality: $quality')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, hr, source, quality);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RingHrSample &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.hr == this.hr &&
          other.source == this.source &&
          other.quality == this.quality);
}

class RingHrSamplesCompanion extends UpdateCompanion<RingHrSample> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<int> hr;
  final Value<String> source;
  final Value<double?> quality;
  const RingHrSamplesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.hr = const Value.absent(),
    this.source = const Value.absent(),
    this.quality = const Value.absent(),
  });
  RingHrSamplesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required int hr,
    required String source,
    this.quality = const Value.absent(),
  }) : timestamp = Value(timestamp),
       hr = Value(hr),
       source = Value(source);
  static Insertable<RingHrSample> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? hr,
    Expression<String>? source,
    Expression<double>? quality,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (hr != null) 'hr': hr,
      if (source != null) 'source': source,
      if (quality != null) 'quality': quality,
    });
  }

  RingHrSamplesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<int>? hr,
    Value<String>? source,
    Value<double?>? quality,
  }) {
    return RingHrSamplesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      hr: hr ?? this.hr,
      source: source ?? this.source,
      quality: quality ?? this.quality,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (hr.present) {
      map['hr'] = Variable<int>(hr.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (quality.present) {
      map['quality'] = Variable<double>(quality.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RingHrSamplesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('hr: $hr, ')
          ..write('source: $source, ')
          ..write('quality: $quality')
          ..write(')'))
        .toString();
  }
}

class $RingSleepStagesTable extends RingSleepStages
    with TableInfo<$RingSleepStagesTable, RingSleepStage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RingSleepStagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nightDateMeta = const VerificationMeta(
    'nightDate',
  );
  @override
  late final GeneratedColumn<DateTime> nightDate = GeneratedColumn<DateTime>(
    'night_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hrAvgMeta = const VerificationMeta('hrAvg');
  @override
  late final GeneratedColumn<int> hrAvg = GeneratedColumn<int>(
    'hr_avg',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempAvgMeta = const VerificationMeta(
    'tempAvg',
  );
  @override
  late final GeneratedColumn<double> tempAvg = GeneratedColumn<double>(
    'temp_avg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nightDate,
    stage,
    startTime,
    endTime,
    hrAvg,
    tempAvg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ring_sleep_stages';
  @override
  VerificationContext validateIntegrity(
    Insertable<RingSleepStage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('night_date')) {
      context.handle(
        _nightDateMeta,
        nightDate.isAcceptableOrUnknown(data['night_date']!, _nightDateMeta),
      );
    } else if (isInserting) {
      context.missing(_nightDateMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('hr_avg')) {
      context.handle(
        _hrAvgMeta,
        hrAvg.isAcceptableOrUnknown(data['hr_avg']!, _hrAvgMeta),
      );
    }
    if (data.containsKey('temp_avg')) {
      context.handle(
        _tempAvgMeta,
        tempAvg.isAcceptableOrUnknown(data['temp_avg']!, _tempAvgMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RingSleepStage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RingSleepStage(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nightDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}night_date'],
          )!,
      stage:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}stage'],
          )!,
      startTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_time'],
          )!,
      endTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}end_time'],
          )!,
      hrAvg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hr_avg'],
      ),
      tempAvg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temp_avg'],
      ),
    );
  }

  @override
  $RingSleepStagesTable createAlias(String alias) {
    return $RingSleepStagesTable(attachedDatabase, alias);
  }
}

class RingSleepStage extends DataClass implements Insertable<RingSleepStage> {
  final int id;
  final DateTime nightDate;
  final String stage;
  final DateTime startTime;
  final DateTime endTime;
  final int? hrAvg;
  final double? tempAvg;
  const RingSleepStage({
    required this.id,
    required this.nightDate,
    required this.stage,
    required this.startTime,
    required this.endTime,
    this.hrAvg,
    this.tempAvg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['night_date'] = Variable<DateTime>(nightDate);
    map['stage'] = Variable<String>(stage);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    if (!nullToAbsent || hrAvg != null) {
      map['hr_avg'] = Variable<int>(hrAvg);
    }
    if (!nullToAbsent || tempAvg != null) {
      map['temp_avg'] = Variable<double>(tempAvg);
    }
    return map;
  }

  RingSleepStagesCompanion toCompanion(bool nullToAbsent) {
    return RingSleepStagesCompanion(
      id: Value(id),
      nightDate: Value(nightDate),
      stage: Value(stage),
      startTime: Value(startTime),
      endTime: Value(endTime),
      hrAvg:
          hrAvg == null && nullToAbsent ? const Value.absent() : Value(hrAvg),
      tempAvg:
          tempAvg == null && nullToAbsent
              ? const Value.absent()
              : Value(tempAvg),
    );
  }

  factory RingSleepStage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RingSleepStage(
      id: serializer.fromJson<int>(json['id']),
      nightDate: serializer.fromJson<DateTime>(json['nightDate']),
      stage: serializer.fromJson<String>(json['stage']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      hrAvg: serializer.fromJson<int?>(json['hrAvg']),
      tempAvg: serializer.fromJson<double?>(json['tempAvg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nightDate': serializer.toJson<DateTime>(nightDate),
      'stage': serializer.toJson<String>(stage),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'hrAvg': serializer.toJson<int?>(hrAvg),
      'tempAvg': serializer.toJson<double?>(tempAvg),
    };
  }

  RingSleepStage copyWith({
    int? id,
    DateTime? nightDate,
    String? stage,
    DateTime? startTime,
    DateTime? endTime,
    Value<int?> hrAvg = const Value.absent(),
    Value<double?> tempAvg = const Value.absent(),
  }) => RingSleepStage(
    id: id ?? this.id,
    nightDate: nightDate ?? this.nightDate,
    stage: stage ?? this.stage,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    hrAvg: hrAvg.present ? hrAvg.value : this.hrAvg,
    tempAvg: tempAvg.present ? tempAvg.value : this.tempAvg,
  );
  RingSleepStage copyWithCompanion(RingSleepStagesCompanion data) {
    return RingSleepStage(
      id: data.id.present ? data.id.value : this.id,
      nightDate: data.nightDate.present ? data.nightDate.value : this.nightDate,
      stage: data.stage.present ? data.stage.value : this.stage,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      hrAvg: data.hrAvg.present ? data.hrAvg.value : this.hrAvg,
      tempAvg: data.tempAvg.present ? data.tempAvg.value : this.tempAvg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RingSleepStage(')
          ..write('id: $id, ')
          ..write('nightDate: $nightDate, ')
          ..write('stage: $stage, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('hrAvg: $hrAvg, ')
          ..write('tempAvg: $tempAvg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nightDate, stage, startTime, endTime, hrAvg, tempAvg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RingSleepStage &&
          other.id == this.id &&
          other.nightDate == this.nightDate &&
          other.stage == this.stage &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.hrAvg == this.hrAvg &&
          other.tempAvg == this.tempAvg);
}

class RingSleepStagesCompanion extends UpdateCompanion<RingSleepStage> {
  final Value<int> id;
  final Value<DateTime> nightDate;
  final Value<String> stage;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int?> hrAvg;
  final Value<double?> tempAvg;
  const RingSleepStagesCompanion({
    this.id = const Value.absent(),
    this.nightDate = const Value.absent(),
    this.stage = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.hrAvg = const Value.absent(),
    this.tempAvg = const Value.absent(),
  });
  RingSleepStagesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime nightDate,
    required String stage,
    required DateTime startTime,
    required DateTime endTime,
    this.hrAvg = const Value.absent(),
    this.tempAvg = const Value.absent(),
  }) : nightDate = Value(nightDate),
       stage = Value(stage),
       startTime = Value(startTime),
       endTime = Value(endTime);
  static Insertable<RingSleepStage> custom({
    Expression<int>? id,
    Expression<DateTime>? nightDate,
    Expression<String>? stage,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? hrAvg,
    Expression<double>? tempAvg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nightDate != null) 'night_date': nightDate,
      if (stage != null) 'stage': stage,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (hrAvg != null) 'hr_avg': hrAvg,
      if (tempAvg != null) 'temp_avg': tempAvg,
    });
  }

  RingSleepStagesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? nightDate,
    Value<String>? stage,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<int?>? hrAvg,
    Value<double?>? tempAvg,
  }) {
    return RingSleepStagesCompanion(
      id: id ?? this.id,
      nightDate: nightDate ?? this.nightDate,
      stage: stage ?? this.stage,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hrAvg: hrAvg ?? this.hrAvg,
      tempAvg: tempAvg ?? this.tempAvg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nightDate.present) {
      map['night_date'] = Variable<DateTime>(nightDate.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (hrAvg.present) {
      map['hr_avg'] = Variable<int>(hrAvg.value);
    }
    if (tempAvg.present) {
      map['temp_avg'] = Variable<double>(tempAvg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RingSleepStagesCompanion(')
          ..write('id: $id, ')
          ..write('nightDate: $nightDate, ')
          ..write('stage: $stage, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('hrAvg: $hrAvg, ')
          ..write('tempAvg: $tempAvg')
          ..write(')'))
        .toString();
  }
}

class $RingStepsTable extends RingSteps
    with TableInfo<$RingStepsTable, RingStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RingStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta(
    'distanceM',
  );
  @override
  late final GeneratedColumn<int> distanceM = GeneratedColumn<int>(
    'distance_m',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    steps,
    calories,
    distanceM,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ring_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<RingStep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    } else if (isInserting) {
      context.missing(_stepsMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('distance_m')) {
      context.handle(
        _distanceMMeta,
        distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta),
      );
    } else if (isInserting) {
      context.missing(_distanceMMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RingStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RingStep(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      steps:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}steps'],
          )!,
      calories:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}calories'],
          )!,
      distanceM:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}distance_m'],
          )!,
    );
  }

  @override
  $RingStepsTable createAlias(String alias) {
    return $RingStepsTable(attachedDatabase, alias);
  }
}

class RingStep extends DataClass implements Insertable<RingStep> {
  final int id;
  final DateTime timestamp;
  final int steps;
  final int calories;
  final int distanceM;
  const RingStep({
    required this.id,
    required this.timestamp,
    required this.steps,
    required this.calories,
    required this.distanceM,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['steps'] = Variable<int>(steps);
    map['calories'] = Variable<int>(calories);
    map['distance_m'] = Variable<int>(distanceM);
    return map;
  }

  RingStepsCompanion toCompanion(bool nullToAbsent) {
    return RingStepsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      steps: Value(steps),
      calories: Value(calories),
      distanceM: Value(distanceM),
    );
  }

  factory RingStep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RingStep(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      steps: serializer.fromJson<int>(json['steps']),
      calories: serializer.fromJson<int>(json['calories']),
      distanceM: serializer.fromJson<int>(json['distanceM']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'steps': serializer.toJson<int>(steps),
      'calories': serializer.toJson<int>(calories),
      'distanceM': serializer.toJson<int>(distanceM),
    };
  }

  RingStep copyWith({
    int? id,
    DateTime? timestamp,
    int? steps,
    int? calories,
    int? distanceM,
  }) => RingStep(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    steps: steps ?? this.steps,
    calories: calories ?? this.calories,
    distanceM: distanceM ?? this.distanceM,
  );
  RingStep copyWithCompanion(RingStepsCompanion data) {
    return RingStep(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      steps: data.steps.present ? data.steps.value : this.steps,
      calories: data.calories.present ? data.calories.value : this.calories,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RingStep(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('steps: $steps, ')
          ..write('calories: $calories, ')
          ..write('distanceM: $distanceM')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, steps, calories, distanceM);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RingStep &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.steps == this.steps &&
          other.calories == this.calories &&
          other.distanceM == this.distanceM);
}

class RingStepsCompanion extends UpdateCompanion<RingStep> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<int> steps;
  final Value<int> calories;
  final Value<int> distanceM;
  const RingStepsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.steps = const Value.absent(),
    this.calories = const Value.absent(),
    this.distanceM = const Value.absent(),
  });
  RingStepsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required int steps,
    required int calories,
    required int distanceM,
  }) : timestamp = Value(timestamp),
       steps = Value(steps),
       calories = Value(calories),
       distanceM = Value(distanceM);
  static Insertable<RingStep> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? steps,
    Expression<int>? calories,
    Expression<int>? distanceM,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (steps != null) 'steps': steps,
      if (calories != null) 'calories': calories,
      if (distanceM != null) 'distance_m': distanceM,
    });
  }

  RingStepsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<int>? steps,
    Value<int>? calories,
    Value<int>? distanceM,
  }) {
    return RingStepsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      distanceM: distanceM ?? this.distanceM,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<int>(distanceM.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RingStepsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('steps: $steps, ')
          ..write('calories: $calories, ')
          ..write('distanceM: $distanceM')
          ..write(')'))
        .toString();
  }
}

abstract class _$PhoenixDatabase extends GeneratedDatabase {
  _$PhoenixDatabase(QueryExecutor e) : super(e);
  $PhoenixDatabaseManager get managers => $PhoenixDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $FastingSessionsTable fastingSessions = $FastingSessionsTable(
    this,
  );
  late final $BiomarkersTable biomarkers = $BiomarkersTable(this);
  late final $ConditioningSessionsTable conditioningSessions =
      $ConditioningSessionsTable(this);
  late final $LlmReportsTable llmReports = $LlmReportsTable(this);
  late final $ProgressionHistoryTable progressionHistory =
      $ProgressionHistoryTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $MealLogsTable mealLogs = $MealLogsTable(this);
  late final $FoodItemsTable foodItems = $FoodItemsTable(this);
  late final $MealTemplatesTable mealTemplates = $MealTemplatesTable(this);
  late final $AssessmentsTable assessments = $AssessmentsTable(this);
  late final $ResearchFeedTable researchFeed = $ResearchFeedTable(this);
  late final $CardioSessionsTable cardioSessions = $CardioSessionsTable(this);
  late final $MesocycleStatesTable mesocycleStates = $MesocycleStatesTable(
    this,
  );
  late final $MesocycleExercisesTable mesocycleExercises =
      $MesocycleExercisesTable(this);
  late final $HrvReadingsTable hrvReadings = $HrvReadingsTable(this);
  late final $Week0SessionsTable week0Sessions = $Week0SessionsTable(this);
  late final $RingDevicesTable ringDevices = $RingDevicesTable(this);
  late final $RingHrSamplesTable ringHrSamples = $RingHrSamplesTable(this);
  late final $RingSleepStagesTable ringSleepStages = $RingSleepStagesTable(
    this,
  );
  late final $RingStepsTable ringSteps = $RingStepsTable(this);
  late final ProgressionDao progressionDao = ProgressionDao(
    this as PhoenixDatabase,
  );
  late final RingDataDao ringDataDao = RingDataDao(this as PhoenixDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercises,
    workoutSessions,
    workoutSets,
    fastingSessions,
    biomarkers,
    conditioningSessions,
    llmReports,
    progressionHistory,
    userSettings,
    userProfiles,
    mealLogs,
    foodItems,
    mealTemplates,
    assessments,
    researchFeed,
    cardioSessions,
    mesocycleStates,
    mesocycleExercises,
    hrvReadings,
    week0Sessions,
    ringDevices,
    ringHrSamples,
    ringSleepStages,
    ringSteps,
  ];
}

typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      required String name,
      required String category,
      Value<int> phoenixLevel,
      Value<String> musclesPrimary,
      Value<String> musclesSecondary,
      Value<String> instructions,
      Value<String> imagePaths,
      Value<String> animationPath,
      Value<int?> progressionNextId,
      Value<int?> progressionPrevId,
      Value<String> advancementCriteria,
      Value<String> equipment,
      Value<String> executionCues,
      Value<int> defaultSets,
      Value<int> defaultRepsMin,
      Value<int> defaultRepsMax,
      Value<int> defaultTempoEcc,
      Value<int> defaultTempoCon,
      Value<String> dayType,
      Value<String> exerciseType,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> category,
      Value<int> phoenixLevel,
      Value<String> musclesPrimary,
      Value<String> musclesSecondary,
      Value<String> instructions,
      Value<String> imagePaths,
      Value<String> animationPath,
      Value<int?> progressionNextId,
      Value<int?> progressionPrevId,
      Value<String> advancementCriteria,
      Value<String> equipment,
      Value<String> executionCues,
      Value<int> defaultSets,
      Value<int> defaultRepsMin,
      Value<int> defaultRepsMax,
      Value<int> defaultTempoEcc,
      Value<int> defaultTempoCon,
      Value<String> dayType,
      Value<String> exerciseType,
    });

final class $$ExercisesTableReferences
    extends BaseReferences<_$PhoenixDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$PhoenixDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: $_aliasNameGenerator(db.exercises.id, db.workoutSets.exerciseId),
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ProgressionHistoryTable,
    List<ProgressionHistoryData>
  >
  _progressionHistoryRefsTable(_$PhoenixDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.progressionHistory,
        aliasName: $_aliasNameGenerator(
          db.exercises.id,
          db.progressionHistory.exerciseId,
        ),
      );

  $$ProgressionHistoryTableProcessedTableManager get progressionHistoryRefs {
    final manager = $$ProgressionHistoryTableTableManager(
      $_db,
      $_db.progressionHistory,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _progressionHistoryRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MesocycleExercisesTable, List<MesocycleExercise>>
  _mesocycleExercisesRefsTable(_$PhoenixDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.mesocycleExercises,
        aliasName: $_aliasNameGenerator(
          db.exercises.id,
          db.mesocycleExercises.exerciseId,
        ),
      );

  $$MesocycleExercisesTableProcessedTableManager get mesocycleExercisesRefs {
    final manager = $$MesocycleExercisesTableTableManager(
      $_db,
      $_db.mesocycleExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _mesocycleExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$PhoenixDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phoenixLevel => $composableBuilder(
    column: $table.phoenixLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get musclesPrimary => $composableBuilder(
    column: $table.musclesPrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get musclesSecondary => $composableBuilder(
    column: $table.musclesSecondary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePaths => $composableBuilder(
    column: $table.imagePaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animationPath => $composableBuilder(
    column: $table.animationPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressionNextId => $composableBuilder(
    column: $table.progressionNextId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressionPrevId => $composableBuilder(
    column: $table.progressionPrevId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get advancementCriteria => $composableBuilder(
    column: $table.advancementCriteria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get executionCues => $composableBuilder(
    column: $table.executionCues,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultSets => $composableBuilder(
    column: $table.defaultSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultRepsMin => $composableBuilder(
    column: $table.defaultRepsMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultRepsMax => $composableBuilder(
    column: $table.defaultRepsMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultTempoEcc => $composableBuilder(
    column: $table.defaultTempoEcc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultTempoCon => $composableBuilder(
    column: $table.defaultTempoCon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> progressionHistoryRefs(
    Expression<bool> Function($$ProgressionHistoryTableFilterComposer f) f,
  ) {
    final $$ProgressionHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressionHistory,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressionHistoryTableFilterComposer(
            $db: $db,
            $table: $db.progressionHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mesocycleExercisesRefs(
    Expression<bool> Function($$MesocycleExercisesTableFilterComposer f) f,
  ) {
    final $$MesocycleExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mesocycleExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MesocycleExercisesTableFilterComposer(
            $db: $db,
            $table: $db.mesocycleExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phoenixLevel => $composableBuilder(
    column: $table.phoenixLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get musclesPrimary => $composableBuilder(
    column: $table.musclesPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get musclesSecondary => $composableBuilder(
    column: $table.musclesSecondary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePaths => $composableBuilder(
    column: $table.imagePaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animationPath => $composableBuilder(
    column: $table.animationPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressionNextId => $composableBuilder(
    column: $table.progressionNextId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressionPrevId => $composableBuilder(
    column: $table.progressionPrevId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get advancementCriteria => $composableBuilder(
    column: $table.advancementCriteria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get executionCues => $composableBuilder(
    column: $table.executionCues,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultSets => $composableBuilder(
    column: $table.defaultSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultRepsMin => $composableBuilder(
    column: $table.defaultRepsMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultRepsMax => $composableBuilder(
    column: $table.defaultRepsMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultTempoEcc => $composableBuilder(
    column: $table.defaultTempoEcc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultTempoCon => $composableBuilder(
    column: $table.defaultTempoCon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get phoenixLevel => $composableBuilder(
    column: $table.phoenixLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get musclesPrimary => $composableBuilder(
    column: $table.musclesPrimary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get musclesSecondary => $composableBuilder(
    column: $table.musclesSecondary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePaths => $composableBuilder(
    column: $table.imagePaths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get animationPath => $composableBuilder(
    column: $table.animationPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progressionNextId => $composableBuilder(
    column: $table.progressionNextId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progressionPrevId => $composableBuilder(
    column: $table.progressionPrevId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get advancementCriteria => $composableBuilder(
    column: $table.advancementCriteria,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get executionCues => $composableBuilder(
    column: $table.executionCues,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultSets => $composableBuilder(
    column: $table.defaultSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultRepsMin => $composableBuilder(
    column: $table.defaultRepsMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultRepsMax => $composableBuilder(
    column: $table.defaultRepsMax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultTempoEcc => $composableBuilder(
    column: $table.defaultTempoEcc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultTempoCon => $composableBuilder(
    column: $table.defaultTempoCon,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dayType =>
      $composableBuilder(column: $table.dayType, builder: (column) => column);

  GeneratedColumn<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => column,
  );

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> progressionHistoryRefs<T extends Object>(
    Expression<T> Function($$ProgressionHistoryTableAnnotationComposer a) f,
  ) {
    final $$ProgressionHistoryTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.progressionHistory,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProgressionHistoryTableAnnotationComposer(
                $db: $db,
                $table: $db.progressionHistory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> mesocycleExercisesRefs<T extends Object>(
    Expression<T> Function($$MesocycleExercisesTableAnnotationComposer a) f,
  ) {
    final $$MesocycleExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.mesocycleExercises,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MesocycleExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.mesocycleExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({
            bool workoutSetsRefs,
            bool progressionHistoryRefs,
            bool mesocycleExercisesRefs,
          })
        > {
  $$ExercisesTableTableManager(_$PhoenixDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> phoenixLevel = const Value.absent(),
                Value<String> musclesPrimary = const Value.absent(),
                Value<String> musclesSecondary = const Value.absent(),
                Value<String> instructions = const Value.absent(),
                Value<String> imagePaths = const Value.absent(),
                Value<String> animationPath = const Value.absent(),
                Value<int?> progressionNextId = const Value.absent(),
                Value<int?> progressionPrevId = const Value.absent(),
                Value<String> advancementCriteria = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<String> executionCues = const Value.absent(),
                Value<int> defaultSets = const Value.absent(),
                Value<int> defaultRepsMin = const Value.absent(),
                Value<int> defaultRepsMax = const Value.absent(),
                Value<int> defaultTempoEcc = const Value.absent(),
                Value<int> defaultTempoCon = const Value.absent(),
                Value<String> dayType = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                category: category,
                phoenixLevel: phoenixLevel,
                musclesPrimary: musclesPrimary,
                musclesSecondary: musclesSecondary,
                instructions: instructions,
                imagePaths: imagePaths,
                animationPath: animationPath,
                progressionNextId: progressionNextId,
                progressionPrevId: progressionPrevId,
                advancementCriteria: advancementCriteria,
                equipment: equipment,
                executionCues: executionCues,
                defaultSets: defaultSets,
                defaultRepsMin: defaultRepsMin,
                defaultRepsMax: defaultRepsMax,
                defaultTempoEcc: defaultTempoEcc,
                defaultTempoCon: defaultTempoCon,
                dayType: dayType,
                exerciseType: exerciseType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String category,
                Value<int> phoenixLevel = const Value.absent(),
                Value<String> musclesPrimary = const Value.absent(),
                Value<String> musclesSecondary = const Value.absent(),
                Value<String> instructions = const Value.absent(),
                Value<String> imagePaths = const Value.absent(),
                Value<String> animationPath = const Value.absent(),
                Value<int?> progressionNextId = const Value.absent(),
                Value<int?> progressionPrevId = const Value.absent(),
                Value<String> advancementCriteria = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<String> executionCues = const Value.absent(),
                Value<int> defaultSets = const Value.absent(),
                Value<int> defaultRepsMin = const Value.absent(),
                Value<int> defaultRepsMax = const Value.absent(),
                Value<int> defaultTempoEcc = const Value.absent(),
                Value<int> defaultTempoCon = const Value.absent(),
                Value<String> dayType = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                category: category,
                phoenixLevel: phoenixLevel,
                musclesPrimary: musclesPrimary,
                musclesSecondary: musclesSecondary,
                instructions: instructions,
                imagePaths: imagePaths,
                animationPath: animationPath,
                progressionNextId: progressionNextId,
                progressionPrevId: progressionPrevId,
                advancementCriteria: advancementCriteria,
                equipment: equipment,
                executionCues: executionCues,
                defaultSets: defaultSets,
                defaultRepsMin: defaultRepsMin,
                defaultRepsMax: defaultRepsMax,
                defaultTempoEcc: defaultTempoEcc,
                defaultTempoCon: defaultTempoCon,
                dayType: dayType,
                exerciseType: exerciseType,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ExercisesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            workoutSetsRefs = false,
            progressionHistoryRefs = false,
            mesocycleExercisesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutSetsRefs) db.workoutSets,
                if (progressionHistoryRefs) db.progressionHistory,
                if (mesocycleExercisesRefs) db.mesocycleExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutSetsRefs)
                    await $_getPrefetchedData<
                      Exercise,
                      $ExercisesTable,
                      WorkoutSet
                    >(
                      currentTable: table,
                      referencedTable: $$ExercisesTableReferences
                          ._workoutSetsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.exerciseId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (progressionHistoryRefs)
                    await $_getPrefetchedData<
                      Exercise,
                      $ExercisesTable,
                      ProgressionHistoryData
                    >(
                      currentTable: table,
                      referencedTable: $$ExercisesTableReferences
                          ._progressionHistoryRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).progressionHistoryRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.exerciseId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (mesocycleExercisesRefs)
                    await $_getPrefetchedData<
                      Exercise,
                      $ExercisesTable,
                      MesocycleExercise
                    >(
                      currentTable: table,
                      referencedTable: $$ExercisesTableReferences
                          ._mesocycleExercisesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).mesocycleExercisesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.exerciseId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({
        bool workoutSetsRefs,
        bool progressionHistoryRefs,
        bool mesocycleExercisesRefs,
      })
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required String type,
      Value<double?> durationMinutes,
      Value<String?> durationScore,
      Value<double?> rpeAverage,
      Value<String> notes,
      Value<String> llmSummaryText,
      Value<bool> warmupCompleted,
      Value<bool> stabilityCompleted,
      Value<bool> cooldownCompleted,
      Value<String?> cooldownType,
      Value<double?> avgHr,
      Value<int?> maxHr,
      Value<double?> avgSpo2,
      Value<double?> avgRmssd,
      Value<String?> bioStatsJson,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String> type,
      Value<double?> durationMinutes,
      Value<String?> durationScore,
      Value<double?> rpeAverage,
      Value<String> notes,
      Value<String> llmSummaryText,
      Value<bool> warmupCompleted,
      Value<bool> stabilityCompleted,
      Value<bool> cooldownCompleted,
      Value<String?> cooldownType,
      Value<double?> avgHr,
      Value<int?> maxHr,
      Value<double?> avgSpo2,
      Value<double?> avgRmssd,
      Value<String?> bioStatsJson,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<
          _$PhoenixDatabase,
          $WorkoutSessionsTable,
          WorkoutSession
        > {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$PhoenixDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: $_aliasNameGenerator(
      db.workoutSessions.id,
      db.workoutSets.sessionId,
    ),
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get durationScore => $composableBuilder(
    column: $table.durationScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpeAverage => $composableBuilder(
    column: $table.rpeAverage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get llmSummaryText => $composableBuilder(
    column: $table.llmSummaryText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get warmupCompleted => $composableBuilder(
    column: $table.warmupCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get stabilityCompleted => $composableBuilder(
    column: $table.stabilityCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cooldownCompleted => $composableBuilder(
    column: $table.cooldownCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cooldownType => $composableBuilder(
    column: $table.cooldownType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgHr => $composableBuilder(
    column: $table.avgHr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHr => $composableBuilder(
    column: $table.maxHr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgSpo2 => $composableBuilder(
    column: $table.avgSpo2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgRmssd => $composableBuilder(
    column: $table.avgRmssd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bioStatsJson => $composableBuilder(
    column: $table.bioStatsJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get durationScore => $composableBuilder(
    column: $table.durationScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpeAverage => $composableBuilder(
    column: $table.rpeAverage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get llmSummaryText => $composableBuilder(
    column: $table.llmSummaryText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get warmupCompleted => $composableBuilder(
    column: $table.warmupCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get stabilityCompleted => $composableBuilder(
    column: $table.stabilityCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cooldownCompleted => $composableBuilder(
    column: $table.cooldownCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cooldownType => $composableBuilder(
    column: $table.cooldownType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgHr => $composableBuilder(
    column: $table.avgHr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHr => $composableBuilder(
    column: $table.maxHr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgSpo2 => $composableBuilder(
    column: $table.avgSpo2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgRmssd => $composableBuilder(
    column: $table.avgRmssd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bioStatsJson => $composableBuilder(
    column: $table.bioStatsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get durationScore => $composableBuilder(
    column: $table.durationScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rpeAverage => $composableBuilder(
    column: $table.rpeAverage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get llmSummaryText => $composableBuilder(
    column: $table.llmSummaryText,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get warmupCompleted => $composableBuilder(
    column: $table.warmupCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get stabilityCompleted => $composableBuilder(
    column: $table.stabilityCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get cooldownCompleted => $composableBuilder(
    column: $table.cooldownCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cooldownType => $composableBuilder(
    column: $table.cooldownType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgHr =>
      $composableBuilder(column: $table.avgHr, builder: (column) => column);

  GeneratedColumn<int> get maxHr =>
      $composableBuilder(column: $table.maxHr, builder: (column) => column);

  GeneratedColumn<double> get avgSpo2 =>
      $composableBuilder(column: $table.avgSpo2, builder: (column) => column);

  GeneratedColumn<double> get avgRmssd =>
      $composableBuilder(column: $table.avgRmssd, builder: (column) => column);

  GeneratedColumn<String> get bioStatsJson => $composableBuilder(
    column: $table.bioStatsJson,
    builder: (column) => column,
  );

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({bool workoutSetsRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$PhoenixDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WorkoutSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$WorkoutSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double?> durationMinutes = const Value.absent(),
                Value<String?> durationScore = const Value.absent(),
                Value<double?> rpeAverage = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> llmSummaryText = const Value.absent(),
                Value<bool> warmupCompleted = const Value.absent(),
                Value<bool> stabilityCompleted = const Value.absent(),
                Value<bool> cooldownCompleted = const Value.absent(),
                Value<String?> cooldownType = const Value.absent(),
                Value<double?> avgHr = const Value.absent(),
                Value<int?> maxHr = const Value.absent(),
                Value<double?> avgSpo2 = const Value.absent(),
                Value<double?> avgRmssd = const Value.absent(),
                Value<String?> bioStatsJson = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                type: type,
                durationMinutes: durationMinutes,
                durationScore: durationScore,
                rpeAverage: rpeAverage,
                notes: notes,
                llmSummaryText: llmSummaryText,
                warmupCompleted: warmupCompleted,
                stabilityCompleted: stabilityCompleted,
                cooldownCompleted: cooldownCompleted,
                cooldownType: cooldownType,
                avgHr: avgHr,
                maxHr: maxHr,
                avgSpo2: avgSpo2,
                avgRmssd: avgRmssd,
                bioStatsJson: bioStatsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required String type,
                Value<double?> durationMinutes = const Value.absent(),
                Value<String?> durationScore = const Value.absent(),
                Value<double?> rpeAverage = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> llmSummaryText = const Value.absent(),
                Value<bool> warmupCompleted = const Value.absent(),
                Value<bool> stabilityCompleted = const Value.absent(),
                Value<bool> cooldownCompleted = const Value.absent(),
                Value<String?> cooldownType = const Value.absent(),
                Value<double?> avgHr = const Value.absent(),
                Value<int?> maxHr = const Value.absent(),
                Value<double?> avgSpo2 = const Value.absent(),
                Value<double?> avgRmssd = const Value.absent(),
                Value<String?> bioStatsJson = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                type: type,
                durationMinutes: durationMinutes,
                durationScore: durationScore,
                rpeAverage: rpeAverage,
                notes: notes,
                llmSummaryText: llmSummaryText,
                warmupCompleted: warmupCompleted,
                stabilityCompleted: stabilityCompleted,
                cooldownCompleted: cooldownCompleted,
                cooldownType: cooldownType,
                avgHr: avgHr,
                maxHr: maxHr,
                avgSpo2: avgSpo2,
                avgRmssd: avgRmssd,
                bioStatsJson: bioStatsJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WorkoutSessionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({workoutSetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (workoutSetsRefs) db.workoutSets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutSetsRefs)
                    await $_getPrefetchedData<
                      WorkoutSession,
                      $WorkoutSessionsTable,
                      WorkoutSet
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSessionsTableReferences
                          ._workoutSetsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.sessionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({bool workoutSetsRefs})
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      required int sessionId,
      required int exerciseId,
      required int setNumber,
      Value<int> repsTarget,
      Value<int> repsCompleted,
      Value<double?> rpe,
      Value<int> tempoEccentric,
      Value<int> tempoConcentric,
      Value<int> restSecondsAfter,
      Value<String> notes,
      Value<double?> avgHr,
      Value<int?> maxHr,
      Value<int?> spo2,
      Value<double?> rmssd,
      Value<double?> stressIndex,
      Value<int?> hrRecoveryBpm,
      Value<double?> skinTemp,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> exerciseId,
      Value<int> setNumber,
      Value<int> repsTarget,
      Value<int> repsCompleted,
      Value<double?> rpe,
      Value<int> tempoEccentric,
      Value<int> tempoConcentric,
      Value<int> restSecondsAfter,
      Value<String> notes,
      Value<double?> avgHr,
      Value<int?> maxHr,
      Value<int?> spo2,
      Value<double?> rmssd,
      Value<double?> stressIndex,
      Value<int?> hrRecoveryBpm,
      Value<double?> skinTemp,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$PhoenixDatabase, $WorkoutSetsTable, WorkoutSet> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$PhoenixDatabase db) =>
      db.workoutSessions.createAlias(
        $_aliasNameGenerator(db.workoutSets.sessionId, db.workoutSessions.id),
      );

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$PhoenixDatabase db) =>
      db.exercises.createAlias(
        $_aliasNameGenerator(db.workoutSets.exerciseId, db.exercises.id),
      );

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsTarget => $composableBuilder(
    column: $table.repsTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsCompleted => $composableBuilder(
    column: $table.repsCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempoEccentric => $composableBuilder(
    column: $table.tempoEccentric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempoConcentric => $composableBuilder(
    column: $table.tempoConcentric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSecondsAfter => $composableBuilder(
    column: $table.restSecondsAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgHr => $composableBuilder(
    column: $table.avgHr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHr => $composableBuilder(
    column: $table.maxHr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spo2 => $composableBuilder(
    column: $table.spo2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rmssd => $composableBuilder(
    column: $table.rmssd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrRecoveryBpm => $composableBuilder(
    column: $table.hrRecoveryBpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get skinTemp => $composableBuilder(
    column: $table.skinTemp,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsTarget => $composableBuilder(
    column: $table.repsTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsCompleted => $composableBuilder(
    column: $table.repsCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempoEccentric => $composableBuilder(
    column: $table.tempoEccentric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempoConcentric => $composableBuilder(
    column: $table.tempoConcentric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSecondsAfter => $composableBuilder(
    column: $table.restSecondsAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgHr => $composableBuilder(
    column: $table.avgHr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHr => $composableBuilder(
    column: $table.maxHr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spo2 => $composableBuilder(
    column: $table.spo2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rmssd => $composableBuilder(
    column: $table.rmssd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrRecoveryBpm => $composableBuilder(
    column: $table.hrRecoveryBpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get skinTemp => $composableBuilder(
    column: $table.skinTemp,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<int> get repsTarget => $composableBuilder(
    column: $table.repsTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repsCompleted => $composableBuilder(
    column: $table.repsCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<int> get tempoEccentric => $composableBuilder(
    column: $table.tempoEccentric,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tempoConcentric => $composableBuilder(
    column: $table.tempoConcentric,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSecondsAfter => $composableBuilder(
    column: $table.restSecondsAfter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get avgHr =>
      $composableBuilder(column: $table.avgHr, builder: (column) => column);

  GeneratedColumn<int> get maxHr =>
      $composableBuilder(column: $table.maxHr, builder: (column) => column);

  GeneratedColumn<int> get spo2 =>
      $composableBuilder(column: $table.spo2, builder: (column) => column);

  GeneratedColumn<double> get rmssd =>
      $composableBuilder(column: $table.rmssd, builder: (column) => column);

  GeneratedColumn<double> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hrRecoveryBpm => $composableBuilder(
    column: $table.hrRecoveryBpm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get skinTemp =>
      $composableBuilder(column: $table.skinTemp, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $WorkoutSetsTable,
          WorkoutSet,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSet, $$WorkoutSetsTableReferences),
          WorkoutSet,
          PrefetchHooks Function({bool sessionId, bool exerciseId})
        > {
  $$WorkoutSetsTableTableManager(_$PhoenixDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<int> repsTarget = const Value.absent(),
                Value<int> repsCompleted = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<int> tempoEccentric = const Value.absent(),
                Value<int> tempoConcentric = const Value.absent(),
                Value<int> restSecondsAfter = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<double?> avgHr = const Value.absent(),
                Value<int?> maxHr = const Value.absent(),
                Value<int?> spo2 = const Value.absent(),
                Value<double?> rmssd = const Value.absent(),
                Value<double?> stressIndex = const Value.absent(),
                Value<int?> hrRecoveryBpm = const Value.absent(),
                Value<double?> skinTemp = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                setNumber: setNumber,
                repsTarget: repsTarget,
                repsCompleted: repsCompleted,
                rpe: rpe,
                tempoEccentric: tempoEccentric,
                tempoConcentric: tempoConcentric,
                restSecondsAfter: restSecondsAfter,
                notes: notes,
                avgHr: avgHr,
                maxHr: maxHr,
                spo2: spo2,
                rmssd: rmssd,
                stressIndex: stressIndex,
                hrRecoveryBpm: hrRecoveryBpm,
                skinTemp: skinTemp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int exerciseId,
                required int setNumber,
                Value<int> repsTarget = const Value.absent(),
                Value<int> repsCompleted = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<int> tempoEccentric = const Value.absent(),
                Value<int> tempoConcentric = const Value.absent(),
                Value<int> restSecondsAfter = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<double?> avgHr = const Value.absent(),
                Value<int?> maxHr = const Value.absent(),
                Value<int?> spo2 = const Value.absent(),
                Value<double?> rmssd = const Value.absent(),
                Value<double?> stressIndex = const Value.absent(),
                Value<int?> hrRecoveryBpm = const Value.absent(),
                Value<double?> skinTemp = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                setNumber: setNumber,
                repsTarget: repsTarget,
                repsCompleted: repsCompleted,
                rpe: rpe,
                tempoEccentric: tempoEccentric,
                tempoConcentric: tempoConcentric,
                restSecondsAfter: restSecondsAfter,
                notes: notes,
                avgHr: avgHr,
                maxHr: maxHr,
                spo2: spo2,
                rmssd: rmssd,
                stressIndex: stressIndex,
                hrRecoveryBpm: hrRecoveryBpm,
                skinTemp: skinTemp,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WorkoutSetsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({sessionId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (sessionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$WorkoutSetsTableReferences
                                ._sessionIdTable(db),
                            referencedColumn:
                                $$WorkoutSetsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (exerciseId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$WorkoutSetsTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn:
                                $$WorkoutSetsTableReferences
                                    ._exerciseIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $WorkoutSetsTable,
      WorkoutSet,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSet, $$WorkoutSetsTableReferences),
      WorkoutSet,
      PrefetchHooks Function({bool sessionId, bool exerciseId})
    >;
typedef $$FastingSessionsTableCreateCompanionBuilder =
    FastingSessionsCompanion Function({
      Value<int> id,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required double targetHours,
      Value<double?> actualHours,
      Value<int> level,
      Value<String> glucoseReadingsJson,
      Value<String> hrvReadingsJson,
      Value<String> refeedingNotes,
      Value<double?> toleranceScore,
      Value<int?> energyScore,
      Value<int> waterCount,
      Value<String> llmSummaryText,
    });
typedef $$FastingSessionsTableUpdateCompanionBuilder =
    FastingSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<double> targetHours,
      Value<double?> actualHours,
      Value<int> level,
      Value<String> glucoseReadingsJson,
      Value<String> hrvReadingsJson,
      Value<String> refeedingNotes,
      Value<double?> toleranceScore,
      Value<int?> energyScore,
      Value<int> waterCount,
      Value<String> llmSummaryText,
    });

class $$FastingSessionsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetHours => $composableBuilder(
    column: $table.targetHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get actualHours => $composableBuilder(
    column: $table.actualHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glucoseReadingsJson => $composableBuilder(
    column: $table.glucoseReadingsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hrvReadingsJson => $composableBuilder(
    column: $table.hrvReadingsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refeedingNotes => $composableBuilder(
    column: $table.refeedingNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get toleranceScore => $composableBuilder(
    column: $table.toleranceScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyScore => $composableBuilder(
    column: $table.energyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterCount => $composableBuilder(
    column: $table.waterCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get llmSummaryText => $composableBuilder(
    column: $table.llmSummaryText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FastingSessionsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetHours => $composableBuilder(
    column: $table.targetHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get actualHours => $composableBuilder(
    column: $table.actualHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glucoseReadingsJson => $composableBuilder(
    column: $table.glucoseReadingsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hrvReadingsJson => $composableBuilder(
    column: $table.hrvReadingsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refeedingNotes => $composableBuilder(
    column: $table.refeedingNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toleranceScore => $composableBuilder(
    column: $table.toleranceScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyScore => $composableBuilder(
    column: $table.energyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterCount => $composableBuilder(
    column: $table.waterCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get llmSummaryText => $composableBuilder(
    column: $table.llmSummaryText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FastingSessionsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<double> get targetHours => $composableBuilder(
    column: $table.targetHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get actualHours => $composableBuilder(
    column: $table.actualHours,
    builder: (column) => column,
  );

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get glucoseReadingsJson => $composableBuilder(
    column: $table.glucoseReadingsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hrvReadingsJson => $composableBuilder(
    column: $table.hrvReadingsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refeedingNotes => $composableBuilder(
    column: $table.refeedingNotes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get toleranceScore => $composableBuilder(
    column: $table.toleranceScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get energyScore => $composableBuilder(
    column: $table.energyScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get waterCount => $composableBuilder(
    column: $table.waterCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get llmSummaryText => $composableBuilder(
    column: $table.llmSummaryText,
    builder: (column) => column,
  );
}

class $$FastingSessionsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $FastingSessionsTable,
          FastingSession,
          $$FastingSessionsTableFilterComposer,
          $$FastingSessionsTableOrderingComposer,
          $$FastingSessionsTableAnnotationComposer,
          $$FastingSessionsTableCreateCompanionBuilder,
          $$FastingSessionsTableUpdateCompanionBuilder,
          (
            FastingSession,
            BaseReferences<
              _$PhoenixDatabase,
              $FastingSessionsTable,
              FastingSession
            >,
          ),
          FastingSession,
          PrefetchHooks Function()
        > {
  $$FastingSessionsTableTableManager(
    _$PhoenixDatabase db,
    $FastingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$FastingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$FastingSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$FastingSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<double> targetHours = const Value.absent(),
                Value<double?> actualHours = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> glucoseReadingsJson = const Value.absent(),
                Value<String> hrvReadingsJson = const Value.absent(),
                Value<String> refeedingNotes = const Value.absent(),
                Value<double?> toleranceScore = const Value.absent(),
                Value<int?> energyScore = const Value.absent(),
                Value<int> waterCount = const Value.absent(),
                Value<String> llmSummaryText = const Value.absent(),
              }) => FastingSessionsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                targetHours: targetHours,
                actualHours: actualHours,
                level: level,
                glucoseReadingsJson: glucoseReadingsJson,
                hrvReadingsJson: hrvReadingsJson,
                refeedingNotes: refeedingNotes,
                toleranceScore: toleranceScore,
                energyScore: energyScore,
                waterCount: waterCount,
                llmSummaryText: llmSummaryText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required double targetHours,
                Value<double?> actualHours = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> glucoseReadingsJson = const Value.absent(),
                Value<String> hrvReadingsJson = const Value.absent(),
                Value<String> refeedingNotes = const Value.absent(),
                Value<double?> toleranceScore = const Value.absent(),
                Value<int?> energyScore = const Value.absent(),
                Value<int> waterCount = const Value.absent(),
                Value<String> llmSummaryText = const Value.absent(),
              }) => FastingSessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                targetHours: targetHours,
                actualHours: actualHours,
                level: level,
                glucoseReadingsJson: glucoseReadingsJson,
                hrvReadingsJson: hrvReadingsJson,
                refeedingNotes: refeedingNotes,
                toleranceScore: toleranceScore,
                energyScore: energyScore,
                waterCount: waterCount,
                llmSummaryText: llmSummaryText,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FastingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $FastingSessionsTable,
      FastingSession,
      $$FastingSessionsTableFilterComposer,
      $$FastingSessionsTableOrderingComposer,
      $$FastingSessionsTableAnnotationComposer,
      $$FastingSessionsTableCreateCompanionBuilder,
      $$FastingSessionsTableUpdateCompanionBuilder,
      (
        FastingSession,
        BaseReferences<
          _$PhoenixDatabase,
          $FastingSessionsTable,
          FastingSession
        >,
      ),
      FastingSession,
      PrefetchHooks Function()
    >;
typedef $$BiomarkersTableCreateCompanionBuilder =
    BiomarkersCompanion Function({
      Value<int> id,
      required DateTime date,
      required String type,
      required String valuesJson,
    });
typedef $$BiomarkersTableUpdateCompanionBuilder =
    BiomarkersCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> type,
      Value<String> valuesJson,
    });

class $$BiomarkersTableFilterComposer
    extends Composer<_$PhoenixDatabase, $BiomarkersTable> {
  $$BiomarkersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BiomarkersTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $BiomarkersTable> {
  $$BiomarkersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BiomarkersTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $BiomarkersTable> {
  $$BiomarkersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => column,
  );
}

class $$BiomarkersTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $BiomarkersTable,
          Biomarker,
          $$BiomarkersTableFilterComposer,
          $$BiomarkersTableOrderingComposer,
          $$BiomarkersTableAnnotationComposer,
          $$BiomarkersTableCreateCompanionBuilder,
          $$BiomarkersTableUpdateCompanionBuilder,
          (
            Biomarker,
            BaseReferences<_$PhoenixDatabase, $BiomarkersTable, Biomarker>,
          ),
          Biomarker,
          PrefetchHooks Function()
        > {
  $$BiomarkersTableTableManager(_$PhoenixDatabase db, $BiomarkersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$BiomarkersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$BiomarkersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$BiomarkersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> valuesJson = const Value.absent(),
              }) => BiomarkersCompanion(
                id: id,
                date: date,
                type: type,
                valuesJson: valuesJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String type,
                required String valuesJson,
              }) => BiomarkersCompanion.insert(
                id: id,
                date: date,
                type: type,
                valuesJson: valuesJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BiomarkersTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $BiomarkersTable,
      Biomarker,
      $$BiomarkersTableFilterComposer,
      $$BiomarkersTableOrderingComposer,
      $$BiomarkersTableAnnotationComposer,
      $$BiomarkersTableCreateCompanionBuilder,
      $$BiomarkersTableUpdateCompanionBuilder,
      (
        Biomarker,
        BaseReferences<_$PhoenixDatabase, $BiomarkersTable, Biomarker>,
      ),
      Biomarker,
      PrefetchHooks Function()
    >;
typedef $$ConditioningSessionsTableCreateCompanionBuilder =
    ConditioningSessionsCompanion Function({
      Value<int> id,
      required DateTime date,
      required String type,
      required int durationSeconds,
      Value<double?> temperature,
      Value<String> notes,
    });
typedef $$ConditioningSessionsTableUpdateCompanionBuilder =
    ConditioningSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> type,
      Value<int> durationSeconds,
      Value<double?> temperature,
      Value<String> notes,
    });

class $$ConditioningSessionsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $ConditioningSessionsTable> {
  $$ConditioningSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConditioningSessionsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $ConditioningSessionsTable> {
  $$ConditioningSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConditioningSessionsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $ConditioningSessionsTable> {
  $$ConditioningSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$ConditioningSessionsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $ConditioningSessionsTable,
          ConditioningSession,
          $$ConditioningSessionsTableFilterComposer,
          $$ConditioningSessionsTableOrderingComposer,
          $$ConditioningSessionsTableAnnotationComposer,
          $$ConditioningSessionsTableCreateCompanionBuilder,
          $$ConditioningSessionsTableUpdateCompanionBuilder,
          (
            ConditioningSession,
            BaseReferences<
              _$PhoenixDatabase,
              $ConditioningSessionsTable,
              ConditioningSession
            >,
          ),
          ConditioningSession,
          PrefetchHooks Function()
        > {
  $$ConditioningSessionsTableTableManager(
    _$PhoenixDatabase db,
    $ConditioningSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ConditioningSessionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ConditioningSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ConditioningSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => ConditioningSessionsCompanion(
                id: id,
                date: date,
                type: type,
                durationSeconds: durationSeconds,
                temperature: temperature,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String type,
                required int durationSeconds,
                Value<double?> temperature = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => ConditioningSessionsCompanion.insert(
                id: id,
                date: date,
                type: type,
                durationSeconds: durationSeconds,
                temperature: temperature,
                notes: notes,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConditioningSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $ConditioningSessionsTable,
      ConditioningSession,
      $$ConditioningSessionsTableFilterComposer,
      $$ConditioningSessionsTableOrderingComposer,
      $$ConditioningSessionsTableAnnotationComposer,
      $$ConditioningSessionsTableCreateCompanionBuilder,
      $$ConditioningSessionsTableUpdateCompanionBuilder,
      (
        ConditioningSession,
        BaseReferences<
          _$PhoenixDatabase,
          $ConditioningSessionsTable,
          ConditioningSession
        >,
      ),
      ConditioningSession,
      PrefetchHooks Function()
    >;
typedef $$LlmReportsTableCreateCompanionBuilder =
    LlmReportsCompanion Function({
      Value<int> id,
      required DateTime generatedAt,
      required String type,
      required String promptTemplate,
      required String contextDataJson,
      required String outputText,
    });
typedef $$LlmReportsTableUpdateCompanionBuilder =
    LlmReportsCompanion Function({
      Value<int> id,
      Value<DateTime> generatedAt,
      Value<String> type,
      Value<String> promptTemplate,
      Value<String> contextDataJson,
      Value<String> outputText,
    });

class $$LlmReportsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $LlmReportsTable> {
  $$LlmReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promptTemplate => $composableBuilder(
    column: $table.promptTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextDataJson => $composableBuilder(
    column: $table.contextDataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outputText => $composableBuilder(
    column: $table.outputText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LlmReportsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $LlmReportsTable> {
  $$LlmReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promptTemplate => $composableBuilder(
    column: $table.promptTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextDataJson => $composableBuilder(
    column: $table.contextDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outputText => $composableBuilder(
    column: $table.outputText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LlmReportsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $LlmReportsTable> {
  $$LlmReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get promptTemplate => $composableBuilder(
    column: $table.promptTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextDataJson => $composableBuilder(
    column: $table.contextDataJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outputText => $composableBuilder(
    column: $table.outputText,
    builder: (column) => column,
  );
}

class $$LlmReportsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $LlmReportsTable,
          LlmReport,
          $$LlmReportsTableFilterComposer,
          $$LlmReportsTableOrderingComposer,
          $$LlmReportsTableAnnotationComposer,
          $$LlmReportsTableCreateCompanionBuilder,
          $$LlmReportsTableUpdateCompanionBuilder,
          (
            LlmReport,
            BaseReferences<_$PhoenixDatabase, $LlmReportsTable, LlmReport>,
          ),
          LlmReport,
          PrefetchHooks Function()
        > {
  $$LlmReportsTableTableManager(_$PhoenixDatabase db, $LlmReportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LlmReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LlmReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$LlmReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> promptTemplate = const Value.absent(),
                Value<String> contextDataJson = const Value.absent(),
                Value<String> outputText = const Value.absent(),
              }) => LlmReportsCompanion(
                id: id,
                generatedAt: generatedAt,
                type: type,
                promptTemplate: promptTemplate,
                contextDataJson: contextDataJson,
                outputText: outputText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime generatedAt,
                required String type,
                required String promptTemplate,
                required String contextDataJson,
                required String outputText,
              }) => LlmReportsCompanion.insert(
                id: id,
                generatedAt: generatedAt,
                type: type,
                promptTemplate: promptTemplate,
                contextDataJson: contextDataJson,
                outputText: outputText,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LlmReportsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $LlmReportsTable,
      LlmReport,
      $$LlmReportsTableFilterComposer,
      $$LlmReportsTableOrderingComposer,
      $$LlmReportsTableAnnotationComposer,
      $$LlmReportsTableCreateCompanionBuilder,
      $$LlmReportsTableUpdateCompanionBuilder,
      (
        LlmReport,
        BaseReferences<_$PhoenixDatabase, $LlmReportsTable, LlmReport>,
      ),
      LlmReport,
      PrefetchHooks Function()
    >;
typedef $$ProgressionHistoryTableCreateCompanionBuilder =
    ProgressionHistoryCompanion Function({
      Value<int> id,
      required int exerciseId,
      required DateTime date,
      required int fromLevel,
      required int toLevel,
      Value<String> criteriaMetJson,
    });
typedef $$ProgressionHistoryTableUpdateCompanionBuilder =
    ProgressionHistoryCompanion Function({
      Value<int> id,
      Value<int> exerciseId,
      Value<DateTime> date,
      Value<int> fromLevel,
      Value<int> toLevel,
      Value<String> criteriaMetJson,
    });

final class $$ProgressionHistoryTableReferences
    extends
        BaseReferences<
          _$PhoenixDatabase,
          $ProgressionHistoryTable,
          ProgressionHistoryData
        > {
  $$ProgressionHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExercisesTable _exerciseIdTable(_$PhoenixDatabase db) =>
      db.exercises.createAlias(
        $_aliasNameGenerator(db.progressionHistory.exerciseId, db.exercises.id),
      );

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProgressionHistoryTableFilterComposer
    extends Composer<_$PhoenixDatabase, $ProgressionHistoryTable> {
  $$ProgressionHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromLevel => $composableBuilder(
    column: $table.fromLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toLevel => $composableBuilder(
    column: $table.toLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get criteriaMetJson => $composableBuilder(
    column: $table.criteriaMetJson,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressionHistoryTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $ProgressionHistoryTable> {
  $$ProgressionHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromLevel => $composableBuilder(
    column: $table.fromLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toLevel => $composableBuilder(
    column: $table.toLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get criteriaMetJson => $composableBuilder(
    column: $table.criteriaMetJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressionHistoryTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $ProgressionHistoryTable> {
  $$ProgressionHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get fromLevel =>
      $composableBuilder(column: $table.fromLevel, builder: (column) => column);

  GeneratedColumn<int> get toLevel =>
      $composableBuilder(column: $table.toLevel, builder: (column) => column);

  GeneratedColumn<String> get criteriaMetJson => $composableBuilder(
    column: $table.criteriaMetJson,
    builder: (column) => column,
  );

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressionHistoryTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $ProgressionHistoryTable,
          ProgressionHistoryData,
          $$ProgressionHistoryTableFilterComposer,
          $$ProgressionHistoryTableOrderingComposer,
          $$ProgressionHistoryTableAnnotationComposer,
          $$ProgressionHistoryTableCreateCompanionBuilder,
          $$ProgressionHistoryTableUpdateCompanionBuilder,
          (ProgressionHistoryData, $$ProgressionHistoryTableReferences),
          ProgressionHistoryData,
          PrefetchHooks Function({bool exerciseId})
        > {
  $$ProgressionHistoryTableTableManager(
    _$PhoenixDatabase db,
    $ProgressionHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ProgressionHistoryTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ProgressionHistoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ProgressionHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> fromLevel = const Value.absent(),
                Value<int> toLevel = const Value.absent(),
                Value<String> criteriaMetJson = const Value.absent(),
              }) => ProgressionHistoryCompanion(
                id: id,
                exerciseId: exerciseId,
                date: date,
                fromLevel: fromLevel,
                toLevel: toLevel,
                criteriaMetJson: criteriaMetJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exerciseId,
                required DateTime date,
                required int fromLevel,
                required int toLevel,
                Value<String> criteriaMetJson = const Value.absent(),
              }) => ProgressionHistoryCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                date: date,
                fromLevel: fromLevel,
                toLevel: toLevel,
                criteriaMetJson: criteriaMetJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ProgressionHistoryTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (exerciseId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$ProgressionHistoryTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn:
                                $$ProgressionHistoryTableReferences
                                    ._exerciseIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProgressionHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $ProgressionHistoryTable,
      ProgressionHistoryData,
      $$ProgressionHistoryTableFilterComposer,
      $$ProgressionHistoryTableOrderingComposer,
      $$ProgressionHistoryTableAnnotationComposer,
      $$ProgressionHistoryTableCreateCompanionBuilder,
      $$ProgressionHistoryTableUpdateCompanionBuilder,
      (ProgressionHistoryData, $$ProgressionHistoryTableReferences),
      ProgressionHistoryData,
      PrefetchHooks Function({bool exerciseId})
    >;
typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      required DateTime createdAt,
      Value<String> settingsJson,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<String> settingsJson,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingsJson => $composableBuilder(
    column: $table.settingsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingsJson => $composableBuilder(
    column: $table.settingsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get settingsJson => $composableBuilder(
    column: $table.settingsJson,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $UserSettingsTable,
          UserSetting,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSetting,
            BaseReferences<_$PhoenixDatabase, $UserSettingsTable, UserSetting>,
          ),
          UserSetting,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(
    _$PhoenixDatabase db,
    $UserSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> settingsJson = const Value.absent(),
              }) => UserSettingsCompanion(
                id: id,
                createdAt: createdAt,
                settingsJson: settingsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime createdAt,
                Value<String> settingsJson = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                id: id,
                createdAt: createdAt,
                settingsJson: settingsJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $UserSettingsTable,
      UserSetting,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSetting,
        BaseReferences<_$PhoenixDatabase, $UserSettingsTable, UserSetting>,
      ),
      UserSetting,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String> name,
      required String sex,
      required int birthYear,
      required double heightCm,
      required double weightKg,
      required String trainingTier,
      required String equipment,
      Value<int?> maxPushups,
      Value<int?> maxSquats,
      Value<int?> plankSeconds,
      Value<int?> restingHr,
      Value<bool> onboardingComplete,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> name,
      Value<String> sex,
      Value<int> birthYear,
      Value<double> heightCm,
      Value<double> weightKg,
      Value<String> trainingTier,
      Value<String> equipment,
      Value<int?> maxPushups,
      Value<int?> maxSquats,
      Value<int?> plankSeconds,
      Value<int?> restingHr,
      Value<bool> onboardingComplete,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$PhoenixDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainingTier => $composableBuilder(
    column: $table.trainingTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPushups => $composableBuilder(
    column: $table.maxPushups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxSquats => $composableBuilder(
    column: $table.maxSquats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plankSeconds => $composableBuilder(
    column: $table.plankSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restingHr => $composableBuilder(
    column: $table.restingHr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainingTier => $composableBuilder(
    column: $table.trainingTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPushups => $composableBuilder(
    column: $table.maxPushups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxSquats => $composableBuilder(
    column: $table.maxSquats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plankSeconds => $composableBuilder(
    column: $table.plankSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restingHr => $composableBuilder(
    column: $table.restingHr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<int> get birthYear =>
      $composableBuilder(column: $table.birthYear, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get trainingTier => $composableBuilder(
    column: $table.trainingTier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<int> get maxPushups => $composableBuilder(
    column: $table.maxPushups,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxSquats =>
      $composableBuilder(column: $table.maxSquats, builder: (column) => column);

  GeneratedColumn<int> get plankSeconds => $composableBuilder(
    column: $table.plankSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restingHr =>
      $composableBuilder(column: $table.restingHr, builder: (column) => column);

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$PhoenixDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(
    _$PhoenixDatabase db,
    $UserProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<int> birthYear = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<String> trainingTier = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<int?> maxPushups = const Value.absent(),
                Value<int?> maxSquats = const Value.absent(),
                Value<int?> plankSeconds = const Value.absent(),
                Value<int?> restingHr = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                name: name,
                sex: sex,
                birthYear: birthYear,
                heightCm: heightCm,
                weightKg: weightKg,
                trainingTier: trainingTier,
                equipment: equipment,
                maxPushups: maxPushups,
                maxSquats: maxSquats,
                plankSeconds: plankSeconds,
                restingHr: restingHr,
                onboardingComplete: onboardingComplete,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String> name = const Value.absent(),
                required String sex,
                required int birthYear,
                required double heightCm,
                required double weightKg,
                required String trainingTier,
                required String equipment,
                Value<int?> maxPushups = const Value.absent(),
                Value<int?> maxSquats = const Value.absent(),
                Value<int?> plankSeconds = const Value.absent(),
                Value<int?> restingHr = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                name: name,
                sex: sex,
                birthYear: birthYear,
                heightCm: heightCm,
                weightKg: weightKg,
                trainingTier: trainingTier,
                equipment: equipment,
                maxPushups: maxPushups,
                maxSquats: maxSquats,
                plankSeconds: plankSeconds,
                restingHr: restingHr,
                onboardingComplete: onboardingComplete,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$PhoenixDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$MealLogsTableCreateCompanionBuilder =
    MealLogsCompanion Function({
      Value<int> id,
      required DateTime date,
      required DateTime mealTime,
      required String description,
      required String proteinEstimate,
      Value<String> feeling,
      Value<String> notes,
      Value<double?> carbEstimate,
      Value<double?> fatEstimate,
      Value<double?> fiberEstimate,
      Value<double?> caloriesEstimate,
    });
typedef $$MealLogsTableUpdateCompanionBuilder =
    MealLogsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<DateTime> mealTime,
      Value<String> description,
      Value<String> proteinEstimate,
      Value<String> feeling,
      Value<String> notes,
      Value<double?> carbEstimate,
      Value<double?> fatEstimate,
      Value<double?> fiberEstimate,
      Value<double?> caloriesEstimate,
    });

class $$MealLogsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $MealLogsTable> {
  $$MealLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get mealTime => $composableBuilder(
    column: $table.mealTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proteinEstimate => $composableBuilder(
    column: $table.proteinEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feeling => $composableBuilder(
    column: $table.feeling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbEstimate => $composableBuilder(
    column: $table.carbEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatEstimate => $composableBuilder(
    column: $table.fatEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberEstimate => $composableBuilder(
    column: $table.fiberEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesEstimate => $composableBuilder(
    column: $table.caloriesEstimate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealLogsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $MealLogsTable> {
  $$MealLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get mealTime => $composableBuilder(
    column: $table.mealTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proteinEstimate => $composableBuilder(
    column: $table.proteinEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feeling => $composableBuilder(
    column: $table.feeling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbEstimate => $composableBuilder(
    column: $table.carbEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatEstimate => $composableBuilder(
    column: $table.fatEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberEstimate => $composableBuilder(
    column: $table.fiberEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesEstimate => $composableBuilder(
    column: $table.caloriesEstimate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealLogsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $MealLogsTable> {
  $$MealLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get mealTime =>
      $composableBuilder(column: $table.mealTime, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get proteinEstimate => $composableBuilder(
    column: $table.proteinEstimate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get feeling =>
      $composableBuilder(column: $table.feeling, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get carbEstimate => $composableBuilder(
    column: $table.carbEstimate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatEstimate => $composableBuilder(
    column: $table.fatEstimate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberEstimate => $composableBuilder(
    column: $table.fiberEstimate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caloriesEstimate => $composableBuilder(
    column: $table.caloriesEstimate,
    builder: (column) => column,
  );
}

class $$MealLogsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $MealLogsTable,
          MealLog,
          $$MealLogsTableFilterComposer,
          $$MealLogsTableOrderingComposer,
          $$MealLogsTableAnnotationComposer,
          $$MealLogsTableCreateCompanionBuilder,
          $$MealLogsTableUpdateCompanionBuilder,
          (MealLog, BaseReferences<_$PhoenixDatabase, $MealLogsTable, MealLog>),
          MealLog,
          PrefetchHooks Function()
        > {
  $$MealLogsTableTableManager(_$PhoenixDatabase db, $MealLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MealLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MealLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MealLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime> mealTime = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> proteinEstimate = const Value.absent(),
                Value<String> feeling = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<double?> carbEstimate = const Value.absent(),
                Value<double?> fatEstimate = const Value.absent(),
                Value<double?> fiberEstimate = const Value.absent(),
                Value<double?> caloriesEstimate = const Value.absent(),
              }) => MealLogsCompanion(
                id: id,
                date: date,
                mealTime: mealTime,
                description: description,
                proteinEstimate: proteinEstimate,
                feeling: feeling,
                notes: notes,
                carbEstimate: carbEstimate,
                fatEstimate: fatEstimate,
                fiberEstimate: fiberEstimate,
                caloriesEstimate: caloriesEstimate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required DateTime mealTime,
                required String description,
                required String proteinEstimate,
                Value<String> feeling = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<double?> carbEstimate = const Value.absent(),
                Value<double?> fatEstimate = const Value.absent(),
                Value<double?> fiberEstimate = const Value.absent(),
                Value<double?> caloriesEstimate = const Value.absent(),
              }) => MealLogsCompanion.insert(
                id: id,
                date: date,
                mealTime: mealTime,
                description: description,
                proteinEstimate: proteinEstimate,
                feeling: feeling,
                notes: notes,
                carbEstimate: carbEstimate,
                fatEstimate: fatEstimate,
                fiberEstimate: fiberEstimate,
                caloriesEstimate: caloriesEstimate,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $MealLogsTable,
      MealLog,
      $$MealLogsTableFilterComposer,
      $$MealLogsTableOrderingComposer,
      $$MealLogsTableAnnotationComposer,
      $$MealLogsTableCreateCompanionBuilder,
      $$MealLogsTableUpdateCompanionBuilder,
      (MealLog, BaseReferences<_$PhoenixDatabase, $MealLogsTable, MealLog>),
      MealLog,
      PrefetchHooks Function()
    >;
typedef $$FoodItemsTableCreateCompanionBuilder =
    FoodItemsCompanion Function({
      Value<int> id,
      required String name,
      required String category,
      required double proteinPer100g,
      required double carbsPer100g,
      required double fatsPer100g,
      required double caloriesPer100g,
      Value<double?> fiberPer100g,
      Value<int?> glycemicIndex,
      required String portionExample,
      required String useIdeas,
      required String longevityBenefit,
      required String activeCompounds,
      required int longevityTier,
      Value<String?> idealTiming,
    });
typedef $$FoodItemsTableUpdateCompanionBuilder =
    FoodItemsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> category,
      Value<double> proteinPer100g,
      Value<double> carbsPer100g,
      Value<double> fatsPer100g,
      Value<double> caloriesPer100g,
      Value<double?> fiberPer100g,
      Value<int?> glycemicIndex,
      Value<String> portionExample,
      Value<String> useIdeas,
      Value<String> longevityBenefit,
      Value<String> activeCompounds,
      Value<int> longevityTier,
      Value<String?> idealTiming,
    });

class $$FoodItemsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $FoodItemsTable> {
  $$FoodItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatsPer100g => $composableBuilder(
    column: $table.fatsPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get glycemicIndex => $composableBuilder(
    column: $table.glycemicIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get portionExample => $composableBuilder(
    column: $table.portionExample,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get useIdeas => $composableBuilder(
    column: $table.useIdeas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get longevityBenefit => $composableBuilder(
    column: $table.longevityBenefit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeCompounds => $composableBuilder(
    column: $table.activeCompounds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longevityTier => $composableBuilder(
    column: $table.longevityTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idealTiming => $composableBuilder(
    column: $table.idealTiming,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodItemsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $FoodItemsTable> {
  $$FoodItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatsPer100g => $composableBuilder(
    column: $table.fatsPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get glycemicIndex => $composableBuilder(
    column: $table.glycemicIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get portionExample => $composableBuilder(
    column: $table.portionExample,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get useIdeas => $composableBuilder(
    column: $table.useIdeas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get longevityBenefit => $composableBuilder(
    column: $table.longevityBenefit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeCompounds => $composableBuilder(
    column: $table.activeCompounds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longevityTier => $composableBuilder(
    column: $table.longevityTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idealTiming => $composableBuilder(
    column: $table.idealTiming,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodItemsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $FoodItemsTable> {
  $$FoodItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatsPer100g => $composableBuilder(
    column: $table.fatsPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<int> get glycemicIndex => $composableBuilder(
    column: $table.glycemicIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get portionExample => $composableBuilder(
    column: $table.portionExample,
    builder: (column) => column,
  );

  GeneratedColumn<String> get useIdeas =>
      $composableBuilder(column: $table.useIdeas, builder: (column) => column);

  GeneratedColumn<String> get longevityBenefit => $composableBuilder(
    column: $table.longevityBenefit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeCompounds => $composableBuilder(
    column: $table.activeCompounds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longevityTier => $composableBuilder(
    column: $table.longevityTier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idealTiming => $composableBuilder(
    column: $table.idealTiming,
    builder: (column) => column,
  );
}

class $$FoodItemsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $FoodItemsTable,
          FoodItem,
          $$FoodItemsTableFilterComposer,
          $$FoodItemsTableOrderingComposer,
          $$FoodItemsTableAnnotationComposer,
          $$FoodItemsTableCreateCompanionBuilder,
          $$FoodItemsTableUpdateCompanionBuilder,
          (
            FoodItem,
            BaseReferences<_$PhoenixDatabase, $FoodItemsTable, FoodItem>,
          ),
          FoodItem,
          PrefetchHooks Function()
        > {
  $$FoodItemsTableTableManager(_$PhoenixDatabase db, $FoodItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FoodItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$FoodItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$FoodItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> proteinPer100g = const Value.absent(),
                Value<double> carbsPer100g = const Value.absent(),
                Value<double> fatsPer100g = const Value.absent(),
                Value<double> caloriesPer100g = const Value.absent(),
                Value<double?> fiberPer100g = const Value.absent(),
                Value<int?> glycemicIndex = const Value.absent(),
                Value<String> portionExample = const Value.absent(),
                Value<String> useIdeas = const Value.absent(),
                Value<String> longevityBenefit = const Value.absent(),
                Value<String> activeCompounds = const Value.absent(),
                Value<int> longevityTier = const Value.absent(),
                Value<String?> idealTiming = const Value.absent(),
              }) => FoodItemsCompanion(
                id: id,
                name: name,
                category: category,
                proteinPer100g: proteinPer100g,
                carbsPer100g: carbsPer100g,
                fatsPer100g: fatsPer100g,
                caloriesPer100g: caloriesPer100g,
                fiberPer100g: fiberPer100g,
                glycemicIndex: glycemicIndex,
                portionExample: portionExample,
                useIdeas: useIdeas,
                longevityBenefit: longevityBenefit,
                activeCompounds: activeCompounds,
                longevityTier: longevityTier,
                idealTiming: idealTiming,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String category,
                required double proteinPer100g,
                required double carbsPer100g,
                required double fatsPer100g,
                required double caloriesPer100g,
                Value<double?> fiberPer100g = const Value.absent(),
                Value<int?> glycemicIndex = const Value.absent(),
                required String portionExample,
                required String useIdeas,
                required String longevityBenefit,
                required String activeCompounds,
                required int longevityTier,
                Value<String?> idealTiming = const Value.absent(),
              }) => FoodItemsCompanion.insert(
                id: id,
                name: name,
                category: category,
                proteinPer100g: proteinPer100g,
                carbsPer100g: carbsPer100g,
                fatsPer100g: fatsPer100g,
                caloriesPer100g: caloriesPer100g,
                fiberPer100g: fiberPer100g,
                glycemicIndex: glycemicIndex,
                portionExample: portionExample,
                useIdeas: useIdeas,
                longevityBenefit: longevityBenefit,
                activeCompounds: activeCompounds,
                longevityTier: longevityTier,
                idealTiming: idealTiming,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $FoodItemsTable,
      FoodItem,
      $$FoodItemsTableFilterComposer,
      $$FoodItemsTableOrderingComposer,
      $$FoodItemsTableAnnotationComposer,
      $$FoodItemsTableCreateCompanionBuilder,
      $$FoodItemsTableUpdateCompanionBuilder,
      (FoodItem, BaseReferences<_$PhoenixDatabase, $FoodItemsTable, FoodItem>),
      FoodItem,
      PrefetchHooks Function()
    >;
typedef $$MealTemplatesTableCreateCompanionBuilder =
    MealTemplatesCompanion Function({
      Value<int> id,
      required String dayType,
      required int mealNumber,
      required String timeSlot,
      required String description,
      required String ingredients,
      required double proteinEstimateG,
      required double caloriesEstimate,
      required String cookingMethod,
      required String timing,
      Value<double?> carbEstimateG,
      Value<double?> fatEstimateG,
      Value<double?> fiberEstimateG,
    });
typedef $$MealTemplatesTableUpdateCompanionBuilder =
    MealTemplatesCompanion Function({
      Value<int> id,
      Value<String> dayType,
      Value<int> mealNumber,
      Value<String> timeSlot,
      Value<String> description,
      Value<String> ingredients,
      Value<double> proteinEstimateG,
      Value<double> caloriesEstimate,
      Value<String> cookingMethod,
      Value<String> timing,
      Value<double?> carbEstimateG,
      Value<double?> fatEstimateG,
      Value<double?> fiberEstimateG,
    });

class $$MealTemplatesTableFilterComposer
    extends Composer<_$PhoenixDatabase, $MealTemplatesTable> {
  $$MealTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mealNumber => $composableBuilder(
    column: $table.mealNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeSlot => $composableBuilder(
    column: $table.timeSlot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinEstimateG => $composableBuilder(
    column: $table.proteinEstimateG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesEstimate => $composableBuilder(
    column: $table.caloriesEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cookingMethod => $composableBuilder(
    column: $table.cookingMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbEstimateG => $composableBuilder(
    column: $table.carbEstimateG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatEstimateG => $composableBuilder(
    column: $table.fatEstimateG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberEstimateG => $composableBuilder(
    column: $table.fiberEstimateG,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealTemplatesTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $MealTemplatesTable> {
  $$MealTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayType => $composableBuilder(
    column: $table.dayType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealNumber => $composableBuilder(
    column: $table.mealNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeSlot => $composableBuilder(
    column: $table.timeSlot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinEstimateG => $composableBuilder(
    column: $table.proteinEstimateG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesEstimate => $composableBuilder(
    column: $table.caloriesEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cookingMethod => $composableBuilder(
    column: $table.cookingMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbEstimateG => $composableBuilder(
    column: $table.carbEstimateG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatEstimateG => $composableBuilder(
    column: $table.fatEstimateG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberEstimateG => $composableBuilder(
    column: $table.fiberEstimateG,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealTemplatesTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $MealTemplatesTable> {
  $$MealTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayType =>
      $composableBuilder(column: $table.dayType, builder: (column) => column);

  GeneratedColumn<int> get mealNumber => $composableBuilder(
    column: $table.mealNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeSlot =>
      $composableBuilder(column: $table.timeSlot, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinEstimateG => $composableBuilder(
    column: $table.proteinEstimateG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caloriesEstimate => $composableBuilder(
    column: $table.caloriesEstimate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cookingMethod => $composableBuilder(
    column: $table.cookingMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timing =>
      $composableBuilder(column: $table.timing, builder: (column) => column);

  GeneratedColumn<double> get carbEstimateG => $composableBuilder(
    column: $table.carbEstimateG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatEstimateG => $composableBuilder(
    column: $table.fatEstimateG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberEstimateG => $composableBuilder(
    column: $table.fiberEstimateG,
    builder: (column) => column,
  );
}

class $$MealTemplatesTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $MealTemplatesTable,
          MealTemplate,
          $$MealTemplatesTableFilterComposer,
          $$MealTemplatesTableOrderingComposer,
          $$MealTemplatesTableAnnotationComposer,
          $$MealTemplatesTableCreateCompanionBuilder,
          $$MealTemplatesTableUpdateCompanionBuilder,
          (
            MealTemplate,
            BaseReferences<
              _$PhoenixDatabase,
              $MealTemplatesTable,
              MealTemplate
            >,
          ),
          MealTemplate,
          PrefetchHooks Function()
        > {
  $$MealTemplatesTableTableManager(
    _$PhoenixDatabase db,
    $MealTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MealTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$MealTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MealTemplatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dayType = const Value.absent(),
                Value<int> mealNumber = const Value.absent(),
                Value<String> timeSlot = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> ingredients = const Value.absent(),
                Value<double> proteinEstimateG = const Value.absent(),
                Value<double> caloriesEstimate = const Value.absent(),
                Value<String> cookingMethod = const Value.absent(),
                Value<String> timing = const Value.absent(),
                Value<double?> carbEstimateG = const Value.absent(),
                Value<double?> fatEstimateG = const Value.absent(),
                Value<double?> fiberEstimateG = const Value.absent(),
              }) => MealTemplatesCompanion(
                id: id,
                dayType: dayType,
                mealNumber: mealNumber,
                timeSlot: timeSlot,
                description: description,
                ingredients: ingredients,
                proteinEstimateG: proteinEstimateG,
                caloriesEstimate: caloriesEstimate,
                cookingMethod: cookingMethod,
                timing: timing,
                carbEstimateG: carbEstimateG,
                fatEstimateG: fatEstimateG,
                fiberEstimateG: fiberEstimateG,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dayType,
                required int mealNumber,
                required String timeSlot,
                required String description,
                required String ingredients,
                required double proteinEstimateG,
                required double caloriesEstimate,
                required String cookingMethod,
                required String timing,
                Value<double?> carbEstimateG = const Value.absent(),
                Value<double?> fatEstimateG = const Value.absent(),
                Value<double?> fiberEstimateG = const Value.absent(),
              }) => MealTemplatesCompanion.insert(
                id: id,
                dayType: dayType,
                mealNumber: mealNumber,
                timeSlot: timeSlot,
                description: description,
                ingredients: ingredients,
                proteinEstimateG: proteinEstimateG,
                caloriesEstimate: caloriesEstimate,
                cookingMethod: cookingMethod,
                timing: timing,
                carbEstimateG: carbEstimateG,
                fatEstimateG: fatEstimateG,
                fiberEstimateG: fiberEstimateG,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $MealTemplatesTable,
      MealTemplate,
      $$MealTemplatesTableFilterComposer,
      $$MealTemplatesTableOrderingComposer,
      $$MealTemplatesTableAnnotationComposer,
      $$MealTemplatesTableCreateCompanionBuilder,
      $$MealTemplatesTableUpdateCompanionBuilder,
      (
        MealTemplate,
        BaseReferences<_$PhoenixDatabase, $MealTemplatesTable, MealTemplate>,
      ),
      MealTemplate,
      PrefetchHooks Function()
    >;
typedef $$AssessmentsTableCreateCompanionBuilder =
    AssessmentsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int?> pushupMaxReps,
      Value<int?> wallSitSeconds,
      Value<int?> plankHoldSeconds,
      Value<double?> sitAndReachCm,
      Value<double?> cooperDistanceM,
      Value<double?> weightKg,
      Value<double?> waistCm,
      Value<double?> chestCm,
      Value<double?> armCm,
      Value<String> notes,
      Value<String> scoresJson,
    });
typedef $$AssessmentsTableUpdateCompanionBuilder =
    AssessmentsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int?> pushupMaxReps,
      Value<int?> wallSitSeconds,
      Value<int?> plankHoldSeconds,
      Value<double?> sitAndReachCm,
      Value<double?> cooperDistanceM,
      Value<double?> weightKg,
      Value<double?> waistCm,
      Value<double?> chestCm,
      Value<double?> armCm,
      Value<String> notes,
      Value<String> scoresJson,
    });

class $$AssessmentsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $AssessmentsTable> {
  $$AssessmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pushupMaxReps => $composableBuilder(
    column: $table.pushupMaxReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wallSitSeconds => $composableBuilder(
    column: $table.wallSitSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plankHoldSeconds => $composableBuilder(
    column: $table.plankHoldSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sitAndReachCm => $composableBuilder(
    column: $table.sitAndReachCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cooperDistanceM => $composableBuilder(
    column: $table.cooperDistanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chestCm => $composableBuilder(
    column: $table.chestCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get armCm => $composableBuilder(
    column: $table.armCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scoresJson => $composableBuilder(
    column: $table.scoresJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssessmentsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $AssessmentsTable> {
  $$AssessmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pushupMaxReps => $composableBuilder(
    column: $table.pushupMaxReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wallSitSeconds => $composableBuilder(
    column: $table.wallSitSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plankHoldSeconds => $composableBuilder(
    column: $table.plankHoldSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sitAndReachCm => $composableBuilder(
    column: $table.sitAndReachCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cooperDistanceM => $composableBuilder(
    column: $table.cooperDistanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chestCm => $composableBuilder(
    column: $table.chestCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get armCm => $composableBuilder(
    column: $table.armCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scoresJson => $composableBuilder(
    column: $table.scoresJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssessmentsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $AssessmentsTable> {
  $$AssessmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get pushupMaxReps => $composableBuilder(
    column: $table.pushupMaxReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wallSitSeconds => $composableBuilder(
    column: $table.wallSitSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plankHoldSeconds => $composableBuilder(
    column: $table.plankHoldSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sitAndReachCm => $composableBuilder(
    column: $table.sitAndReachCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cooperDistanceM => $composableBuilder(
    column: $table.cooperDistanceM,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get waistCm =>
      $composableBuilder(column: $table.waistCm, builder: (column) => column);

  GeneratedColumn<double> get chestCm =>
      $composableBuilder(column: $table.chestCm, builder: (column) => column);

  GeneratedColumn<double> get armCm =>
      $composableBuilder(column: $table.armCm, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get scoresJson => $composableBuilder(
    column: $table.scoresJson,
    builder: (column) => column,
  );
}

class $$AssessmentsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $AssessmentsTable,
          Assessment,
          $$AssessmentsTableFilterComposer,
          $$AssessmentsTableOrderingComposer,
          $$AssessmentsTableAnnotationComposer,
          $$AssessmentsTableCreateCompanionBuilder,
          $$AssessmentsTableUpdateCompanionBuilder,
          (
            Assessment,
            BaseReferences<_$PhoenixDatabase, $AssessmentsTable, Assessment>,
          ),
          Assessment,
          PrefetchHooks Function()
        > {
  $$AssessmentsTableTableManager(_$PhoenixDatabase db, $AssessmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AssessmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AssessmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AssessmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> pushupMaxReps = const Value.absent(),
                Value<int?> wallSitSeconds = const Value.absent(),
                Value<int?> plankHoldSeconds = const Value.absent(),
                Value<double?> sitAndReachCm = const Value.absent(),
                Value<double?> cooperDistanceM = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<double?> chestCm = const Value.absent(),
                Value<double?> armCm = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> scoresJson = const Value.absent(),
              }) => AssessmentsCompanion(
                id: id,
                date: date,
                pushupMaxReps: pushupMaxReps,
                wallSitSeconds: wallSitSeconds,
                plankHoldSeconds: plankHoldSeconds,
                sitAndReachCm: sitAndReachCm,
                cooperDistanceM: cooperDistanceM,
                weightKg: weightKg,
                waistCm: waistCm,
                chestCm: chestCm,
                armCm: armCm,
                notes: notes,
                scoresJson: scoresJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int?> pushupMaxReps = const Value.absent(),
                Value<int?> wallSitSeconds = const Value.absent(),
                Value<int?> plankHoldSeconds = const Value.absent(),
                Value<double?> sitAndReachCm = const Value.absent(),
                Value<double?> cooperDistanceM = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<double?> chestCm = const Value.absent(),
                Value<double?> armCm = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> scoresJson = const Value.absent(),
              }) => AssessmentsCompanion.insert(
                id: id,
                date: date,
                pushupMaxReps: pushupMaxReps,
                wallSitSeconds: wallSitSeconds,
                plankHoldSeconds: plankHoldSeconds,
                sitAndReachCm: sitAndReachCm,
                cooperDistanceM: cooperDistanceM,
                weightKg: weightKg,
                waistCm: waistCm,
                chestCm: chestCm,
                armCm: armCm,
                notes: notes,
                scoresJson: scoresJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssessmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $AssessmentsTable,
      Assessment,
      $$AssessmentsTableFilterComposer,
      $$AssessmentsTableOrderingComposer,
      $$AssessmentsTableAnnotationComposer,
      $$AssessmentsTableCreateCompanionBuilder,
      $$AssessmentsTableUpdateCompanionBuilder,
      (
        Assessment,
        BaseReferences<_$PhoenixDatabase, $AssessmentsTable, Assessment>,
      ),
      Assessment,
      PrefetchHooks Function()
    >;
typedef $$ResearchFeedTableCreateCompanionBuilder =
    ResearchFeedCompanion Function({
      Value<int> id,
      required DateTime foundDate,
      required String source,
      required String language,
      required String title,
      required String abstractText,
      Value<String?> doi,
      required String url,
      required String area,
      required String keySummary,
      required String impact,
      Value<bool> userRead,
      Value<bool> proposedUpdate,
      Value<String?> updateProposal,
      Value<String?> updateStatus,
    });
typedef $$ResearchFeedTableUpdateCompanionBuilder =
    ResearchFeedCompanion Function({
      Value<int> id,
      Value<DateTime> foundDate,
      Value<String> source,
      Value<String> language,
      Value<String> title,
      Value<String> abstractText,
      Value<String?> doi,
      Value<String> url,
      Value<String> area,
      Value<String> keySummary,
      Value<String> impact,
      Value<bool> userRead,
      Value<bool> proposedUpdate,
      Value<String?> updateProposal,
      Value<String?> updateStatus,
    });

class $$ResearchFeedTableFilterComposer
    extends Composer<_$PhoenixDatabase, $ResearchFeedTable> {
  $$ResearchFeedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get foundDate => $composableBuilder(
    column: $table.foundDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abstractText => $composableBuilder(
    column: $table.abstractText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doi => $composableBuilder(
    column: $table.doi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keySummary => $composableBuilder(
    column: $table.keySummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get impact => $composableBuilder(
    column: $table.impact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userRead => $composableBuilder(
    column: $table.userRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get proposedUpdate => $composableBuilder(
    column: $table.proposedUpdate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updateProposal => $composableBuilder(
    column: $table.updateProposal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updateStatus => $composableBuilder(
    column: $table.updateStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ResearchFeedTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $ResearchFeedTable> {
  $$ResearchFeedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get foundDate => $composableBuilder(
    column: $table.foundDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abstractText => $composableBuilder(
    column: $table.abstractText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doi => $composableBuilder(
    column: $table.doi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keySummary => $composableBuilder(
    column: $table.keySummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get impact => $composableBuilder(
    column: $table.impact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userRead => $composableBuilder(
    column: $table.userRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get proposedUpdate => $composableBuilder(
    column: $table.proposedUpdate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updateProposal => $composableBuilder(
    column: $table.updateProposal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updateStatus => $composableBuilder(
    column: $table.updateStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ResearchFeedTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $ResearchFeedTable> {
  $$ResearchFeedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get foundDate =>
      $composableBuilder(column: $table.foundDate, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get abstractText => $composableBuilder(
    column: $table.abstractText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get doi =>
      $composableBuilder(column: $table.doi, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get keySummary => $composableBuilder(
    column: $table.keySummary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get impact =>
      $composableBuilder(column: $table.impact, builder: (column) => column);

  GeneratedColumn<bool> get userRead =>
      $composableBuilder(column: $table.userRead, builder: (column) => column);

  GeneratedColumn<bool> get proposedUpdate => $composableBuilder(
    column: $table.proposedUpdate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updateProposal => $composableBuilder(
    column: $table.updateProposal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get updateStatus => $composableBuilder(
    column: $table.updateStatus,
    builder: (column) => column,
  );
}

class $$ResearchFeedTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $ResearchFeedTable,
          ResearchFeedData,
          $$ResearchFeedTableFilterComposer,
          $$ResearchFeedTableOrderingComposer,
          $$ResearchFeedTableAnnotationComposer,
          $$ResearchFeedTableCreateCompanionBuilder,
          $$ResearchFeedTableUpdateCompanionBuilder,
          (
            ResearchFeedData,
            BaseReferences<
              _$PhoenixDatabase,
              $ResearchFeedTable,
              ResearchFeedData
            >,
          ),
          ResearchFeedData,
          PrefetchHooks Function()
        > {
  $$ResearchFeedTableTableManager(
    _$PhoenixDatabase db,
    $ResearchFeedTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ResearchFeedTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ResearchFeedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$ResearchFeedTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> foundDate = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> abstractText = const Value.absent(),
                Value<String?> doi = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> area = const Value.absent(),
                Value<String> keySummary = const Value.absent(),
                Value<String> impact = const Value.absent(),
                Value<bool> userRead = const Value.absent(),
                Value<bool> proposedUpdate = const Value.absent(),
                Value<String?> updateProposal = const Value.absent(),
                Value<String?> updateStatus = const Value.absent(),
              }) => ResearchFeedCompanion(
                id: id,
                foundDate: foundDate,
                source: source,
                language: language,
                title: title,
                abstractText: abstractText,
                doi: doi,
                url: url,
                area: area,
                keySummary: keySummary,
                impact: impact,
                userRead: userRead,
                proposedUpdate: proposedUpdate,
                updateProposal: updateProposal,
                updateStatus: updateStatus,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime foundDate,
                required String source,
                required String language,
                required String title,
                required String abstractText,
                Value<String?> doi = const Value.absent(),
                required String url,
                required String area,
                required String keySummary,
                required String impact,
                Value<bool> userRead = const Value.absent(),
                Value<bool> proposedUpdate = const Value.absent(),
                Value<String?> updateProposal = const Value.absent(),
                Value<String?> updateStatus = const Value.absent(),
              }) => ResearchFeedCompanion.insert(
                id: id,
                foundDate: foundDate,
                source: source,
                language: language,
                title: title,
                abstractText: abstractText,
                doi: doi,
                url: url,
                area: area,
                keySummary: keySummary,
                impact: impact,
                userRead: userRead,
                proposedUpdate: proposedUpdate,
                updateProposal: updateProposal,
                updateStatus: updateStatus,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ResearchFeedTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $ResearchFeedTable,
      ResearchFeedData,
      $$ResearchFeedTableFilterComposer,
      $$ResearchFeedTableOrderingComposer,
      $$ResearchFeedTableAnnotationComposer,
      $$ResearchFeedTableCreateCompanionBuilder,
      $$ResearchFeedTableUpdateCompanionBuilder,
      (
        ResearchFeedData,
        BaseReferences<_$PhoenixDatabase, $ResearchFeedTable, ResearchFeedData>,
      ),
      ResearchFeedData,
      PrefetchHooks Function()
    >;
typedef $$CardioSessionsTableCreateCompanionBuilder =
    CardioSessionsCompanion Function({
      Value<int> id,
      required DateTime date,
      required String protocol,
      Value<int> roundsCompleted,
      Value<int> roundsTotal,
      Value<int> totalDurationSeconds,
      Value<int> zone2Minutes,
      Value<int?> avgHrEstimated,
      Value<int?> perceivedExertion,
      Value<String> modality,
      Value<String> notes,
    });
typedef $$CardioSessionsTableUpdateCompanionBuilder =
    CardioSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> protocol,
      Value<int> roundsCompleted,
      Value<int> roundsTotal,
      Value<int> totalDurationSeconds,
      Value<int> zone2Minutes,
      Value<int?> avgHrEstimated,
      Value<int?> perceivedExertion,
      Value<String> modality,
      Value<String> notes,
    });

class $$CardioSessionsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $CardioSessionsTable> {
  $$CardioSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get protocol => $composableBuilder(
    column: $table.protocol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roundsCompleted => $composableBuilder(
    column: $table.roundsCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roundsTotal => $composableBuilder(
    column: $table.roundsTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zone2Minutes => $composableBuilder(
    column: $table.zone2Minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgHrEstimated => $composableBuilder(
    column: $table.avgHrEstimated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get perceivedExertion => $composableBuilder(
    column: $table.perceivedExertion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modality => $composableBuilder(
    column: $table.modality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardioSessionsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $CardioSessionsTable> {
  $$CardioSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get protocol => $composableBuilder(
    column: $table.protocol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roundsCompleted => $composableBuilder(
    column: $table.roundsCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roundsTotal => $composableBuilder(
    column: $table.roundsTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zone2Minutes => $composableBuilder(
    column: $table.zone2Minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgHrEstimated => $composableBuilder(
    column: $table.avgHrEstimated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get perceivedExertion => $composableBuilder(
    column: $table.perceivedExertion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modality => $composableBuilder(
    column: $table.modality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardioSessionsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $CardioSessionsTable> {
  $$CardioSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get protocol =>
      $composableBuilder(column: $table.protocol, builder: (column) => column);

  GeneratedColumn<int> get roundsCompleted => $composableBuilder(
    column: $table.roundsCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get roundsTotal => $composableBuilder(
    column: $table.roundsTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get zone2Minutes => $composableBuilder(
    column: $table.zone2Minutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get avgHrEstimated => $composableBuilder(
    column: $table.avgHrEstimated,
    builder: (column) => column,
  );

  GeneratedColumn<int> get perceivedExertion => $composableBuilder(
    column: $table.perceivedExertion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modality =>
      $composableBuilder(column: $table.modality, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$CardioSessionsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $CardioSessionsTable,
          CardioSession,
          $$CardioSessionsTableFilterComposer,
          $$CardioSessionsTableOrderingComposer,
          $$CardioSessionsTableAnnotationComposer,
          $$CardioSessionsTableCreateCompanionBuilder,
          $$CardioSessionsTableUpdateCompanionBuilder,
          (
            CardioSession,
            BaseReferences<
              _$PhoenixDatabase,
              $CardioSessionsTable,
              CardioSession
            >,
          ),
          CardioSession,
          PrefetchHooks Function()
        > {
  $$CardioSessionsTableTableManager(
    _$PhoenixDatabase db,
    $CardioSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CardioSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$CardioSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CardioSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> protocol = const Value.absent(),
                Value<int> roundsCompleted = const Value.absent(),
                Value<int> roundsTotal = const Value.absent(),
                Value<int> totalDurationSeconds = const Value.absent(),
                Value<int> zone2Minutes = const Value.absent(),
                Value<int?> avgHrEstimated = const Value.absent(),
                Value<int?> perceivedExertion = const Value.absent(),
                Value<String> modality = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => CardioSessionsCompanion(
                id: id,
                date: date,
                protocol: protocol,
                roundsCompleted: roundsCompleted,
                roundsTotal: roundsTotal,
                totalDurationSeconds: totalDurationSeconds,
                zone2Minutes: zone2Minutes,
                avgHrEstimated: avgHrEstimated,
                perceivedExertion: perceivedExertion,
                modality: modality,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String protocol,
                Value<int> roundsCompleted = const Value.absent(),
                Value<int> roundsTotal = const Value.absent(),
                Value<int> totalDurationSeconds = const Value.absent(),
                Value<int> zone2Minutes = const Value.absent(),
                Value<int?> avgHrEstimated = const Value.absent(),
                Value<int?> perceivedExertion = const Value.absent(),
                Value<String> modality = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => CardioSessionsCompanion.insert(
                id: id,
                date: date,
                protocol: protocol,
                roundsCompleted: roundsCompleted,
                roundsTotal: roundsTotal,
                totalDurationSeconds: totalDurationSeconds,
                zone2Minutes: zone2Minutes,
                avgHrEstimated: avgHrEstimated,
                perceivedExertion: perceivedExertion,
                modality: modality,
                notes: notes,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardioSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $CardioSessionsTable,
      CardioSession,
      $$CardioSessionsTableFilterComposer,
      $$CardioSessionsTableOrderingComposer,
      $$CardioSessionsTableAnnotationComposer,
      $$CardioSessionsTableCreateCompanionBuilder,
      $$CardioSessionsTableUpdateCompanionBuilder,
      (
        CardioSession,
        BaseReferences<_$PhoenixDatabase, $CardioSessionsTable, CardioSession>,
      ),
      CardioSession,
      PrefetchHooks Function()
    >;
typedef $$MesocycleStatesTableCreateCompanionBuilder =
    MesocycleStatesCompanion Function({
      Value<int> id,
      required String tier,
      Value<int> mesocycleNumber,
      Value<int> weekInMesocycle,
      Value<String?> currentBlock,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
    });
typedef $$MesocycleStatesTableUpdateCompanionBuilder =
    MesocycleStatesCompanion Function({
      Value<int> id,
      Value<String> tier,
      Value<int> mesocycleNumber,
      Value<int> weekInMesocycle,
      Value<String?> currentBlock,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
    });

class $$MesocycleStatesTableFilterComposer
    extends Composer<_$PhoenixDatabase, $MesocycleStatesTable> {
  $$MesocycleStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mesocycleNumber => $composableBuilder(
    column: $table.mesocycleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekInMesocycle => $composableBuilder(
    column: $table.weekInMesocycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentBlock => $composableBuilder(
    column: $table.currentBlock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MesocycleStatesTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $MesocycleStatesTable> {
  $$MesocycleStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mesocycleNumber => $composableBuilder(
    column: $table.mesocycleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekInMesocycle => $composableBuilder(
    column: $table.weekInMesocycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentBlock => $composableBuilder(
    column: $table.currentBlock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MesocycleStatesTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $MesocycleStatesTable> {
  $$MesocycleStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<int> get mesocycleNumber => $composableBuilder(
    column: $table.mesocycleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekInMesocycle => $composableBuilder(
    column: $table.weekInMesocycle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentBlock => $composableBuilder(
    column: $table.currentBlock,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$MesocycleStatesTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $MesocycleStatesTable,
          MesocycleState,
          $$MesocycleStatesTableFilterComposer,
          $$MesocycleStatesTableOrderingComposer,
          $$MesocycleStatesTableAnnotationComposer,
          $$MesocycleStatesTableCreateCompanionBuilder,
          $$MesocycleStatesTableUpdateCompanionBuilder,
          (
            MesocycleState,
            BaseReferences<
              _$PhoenixDatabase,
              $MesocycleStatesTable,
              MesocycleState
            >,
          ),
          MesocycleState,
          PrefetchHooks Function()
        > {
  $$MesocycleStatesTableTableManager(
    _$PhoenixDatabase db,
    $MesocycleStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$MesocycleStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MesocycleStatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$MesocycleStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<int> mesocycleNumber = const Value.absent(),
                Value<int> weekInMesocycle = const Value.absent(),
                Value<String?> currentBlock = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => MesocycleStatesCompanion(
                id: id,
                tier: tier,
                mesocycleNumber: mesocycleNumber,
                weekInMesocycle: weekInMesocycle,
                currentBlock: currentBlock,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tier,
                Value<int> mesocycleNumber = const Value.absent(),
                Value<int> weekInMesocycle = const Value.absent(),
                Value<String?> currentBlock = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
              }) => MesocycleStatesCompanion.insert(
                id: id,
                tier: tier,
                mesocycleNumber: mesocycleNumber,
                weekInMesocycle: weekInMesocycle,
                currentBlock: currentBlock,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MesocycleStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $MesocycleStatesTable,
      MesocycleState,
      $$MesocycleStatesTableFilterComposer,
      $$MesocycleStatesTableOrderingComposer,
      $$MesocycleStatesTableAnnotationComposer,
      $$MesocycleStatesTableCreateCompanionBuilder,
      $$MesocycleStatesTableUpdateCompanionBuilder,
      (
        MesocycleState,
        BaseReferences<
          _$PhoenixDatabase,
          $MesocycleStatesTable,
          MesocycleState
        >,
      ),
      MesocycleState,
      PrefetchHooks Function()
    >;
typedef $$MesocycleExercisesTableCreateCompanionBuilder =
    MesocycleExercisesCompanion Function({
      Value<int> id,
      required int mesocycleNumber,
      required String slotCategory,
      required String slotType,
      required int slotIndex,
      required int exerciseId,
      Value<bool> locked,
    });
typedef $$MesocycleExercisesTableUpdateCompanionBuilder =
    MesocycleExercisesCompanion Function({
      Value<int> id,
      Value<int> mesocycleNumber,
      Value<String> slotCategory,
      Value<String> slotType,
      Value<int> slotIndex,
      Value<int> exerciseId,
      Value<bool> locked,
    });

final class $$MesocycleExercisesTableReferences
    extends
        BaseReferences<
          _$PhoenixDatabase,
          $MesocycleExercisesTable,
          MesocycleExercise
        > {
  $$MesocycleExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExercisesTable _exerciseIdTable(_$PhoenixDatabase db) =>
      db.exercises.createAlias(
        $_aliasNameGenerator(db.mesocycleExercises.exerciseId, db.exercises.id),
      );

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MesocycleExercisesTableFilterComposer
    extends Composer<_$PhoenixDatabase, $MesocycleExercisesTable> {
  $$MesocycleExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mesocycleNumber => $composableBuilder(
    column: $table.mesocycleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slotCategory => $composableBuilder(
    column: $table.slotCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slotType => $composableBuilder(
    column: $table.slotType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slotIndex => $composableBuilder(
    column: $table.slotIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get locked => $composableBuilder(
    column: $table.locked,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MesocycleExercisesTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $MesocycleExercisesTable> {
  $$MesocycleExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mesocycleNumber => $composableBuilder(
    column: $table.mesocycleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slotCategory => $composableBuilder(
    column: $table.slotCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slotType => $composableBuilder(
    column: $table.slotType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slotIndex => $composableBuilder(
    column: $table.slotIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get locked => $composableBuilder(
    column: $table.locked,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MesocycleExercisesTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $MesocycleExercisesTable> {
  $$MesocycleExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get mesocycleNumber => $composableBuilder(
    column: $table.mesocycleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slotCategory => $composableBuilder(
    column: $table.slotCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slotType =>
      $composableBuilder(column: $table.slotType, builder: (column) => column);

  GeneratedColumn<int> get slotIndex =>
      $composableBuilder(column: $table.slotIndex, builder: (column) => column);

  GeneratedColumn<bool> get locked =>
      $composableBuilder(column: $table.locked, builder: (column) => column);

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MesocycleExercisesTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $MesocycleExercisesTable,
          MesocycleExercise,
          $$MesocycleExercisesTableFilterComposer,
          $$MesocycleExercisesTableOrderingComposer,
          $$MesocycleExercisesTableAnnotationComposer,
          $$MesocycleExercisesTableCreateCompanionBuilder,
          $$MesocycleExercisesTableUpdateCompanionBuilder,
          (MesocycleExercise, $$MesocycleExercisesTableReferences),
          MesocycleExercise,
          PrefetchHooks Function({bool exerciseId})
        > {
  $$MesocycleExercisesTableTableManager(
    _$PhoenixDatabase db,
    $MesocycleExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MesocycleExercisesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$MesocycleExercisesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$MesocycleExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mesocycleNumber = const Value.absent(),
                Value<String> slotCategory = const Value.absent(),
                Value<String> slotType = const Value.absent(),
                Value<int> slotIndex = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<bool> locked = const Value.absent(),
              }) => MesocycleExercisesCompanion(
                id: id,
                mesocycleNumber: mesocycleNumber,
                slotCategory: slotCategory,
                slotType: slotType,
                slotIndex: slotIndex,
                exerciseId: exerciseId,
                locked: locked,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mesocycleNumber,
                required String slotCategory,
                required String slotType,
                required int slotIndex,
                required int exerciseId,
                Value<bool> locked = const Value.absent(),
              }) => MesocycleExercisesCompanion.insert(
                id: id,
                mesocycleNumber: mesocycleNumber,
                slotCategory: slotCategory,
                slotType: slotType,
                slotIndex: slotIndex,
                exerciseId: exerciseId,
                locked: locked,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$MesocycleExercisesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (exerciseId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$MesocycleExercisesTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn:
                                $$MesocycleExercisesTableReferences
                                    ._exerciseIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MesocycleExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $MesocycleExercisesTable,
      MesocycleExercise,
      $$MesocycleExercisesTableFilterComposer,
      $$MesocycleExercisesTableOrderingComposer,
      $$MesocycleExercisesTableAnnotationComposer,
      $$MesocycleExercisesTableCreateCompanionBuilder,
      $$MesocycleExercisesTableUpdateCompanionBuilder,
      (MesocycleExercise, $$MesocycleExercisesTableReferences),
      MesocycleExercise,
      PrefetchHooks Function({bool exerciseId})
    >;
typedef $$HrvReadingsTableCreateCompanionBuilder =
    HrvReadingsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required double rmssd,
      required double lnRmssd,
      Value<double?> stressIndex,
      required String source,
      Value<String> context,
    });
typedef $$HrvReadingsTableUpdateCompanionBuilder =
    HrvReadingsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<double> rmssd,
      Value<double> lnRmssd,
      Value<double?> stressIndex,
      Value<String> source,
      Value<String> context,
    });

class $$HrvReadingsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $HrvReadingsTable> {
  $$HrvReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rmssd => $composableBuilder(
    column: $table.rmssd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lnRmssd => $composableBuilder(
    column: $table.lnRmssd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HrvReadingsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $HrvReadingsTable> {
  $$HrvReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rmssd => $composableBuilder(
    column: $table.rmssd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lnRmssd => $composableBuilder(
    column: $table.lnRmssd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get context => $composableBuilder(
    column: $table.context,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HrvReadingsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $HrvReadingsTable> {
  $$HrvReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get rmssd =>
      $composableBuilder(column: $table.rmssd, builder: (column) => column);

  GeneratedColumn<double> get lnRmssd =>
      $composableBuilder(column: $table.lnRmssd, builder: (column) => column);

  GeneratedColumn<double> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get context =>
      $composableBuilder(column: $table.context, builder: (column) => column);
}

class $$HrvReadingsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $HrvReadingsTable,
          HrvReading,
          $$HrvReadingsTableFilterComposer,
          $$HrvReadingsTableOrderingComposer,
          $$HrvReadingsTableAnnotationComposer,
          $$HrvReadingsTableCreateCompanionBuilder,
          $$HrvReadingsTableUpdateCompanionBuilder,
          (
            HrvReading,
            BaseReferences<_$PhoenixDatabase, $HrvReadingsTable, HrvReading>,
          ),
          HrvReading,
          PrefetchHooks Function()
        > {
  $$HrvReadingsTableTableManager(_$PhoenixDatabase db, $HrvReadingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$HrvReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$HrvReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$HrvReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> rmssd = const Value.absent(),
                Value<double> lnRmssd = const Value.absent(),
                Value<double?> stressIndex = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> context = const Value.absent(),
              }) => HrvReadingsCompanion(
                id: id,
                timestamp: timestamp,
                rmssd: rmssd,
                lnRmssd: lnRmssd,
                stressIndex: stressIndex,
                source: source,
                context: context,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required double rmssd,
                required double lnRmssd,
                Value<double?> stressIndex = const Value.absent(),
                required String source,
                Value<String> context = const Value.absent(),
              }) => HrvReadingsCompanion.insert(
                id: id,
                timestamp: timestamp,
                rmssd: rmssd,
                lnRmssd: lnRmssd,
                stressIndex: stressIndex,
                source: source,
                context: context,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HrvReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $HrvReadingsTable,
      HrvReading,
      $$HrvReadingsTableFilterComposer,
      $$HrvReadingsTableOrderingComposer,
      $$HrvReadingsTableAnnotationComposer,
      $$HrvReadingsTableCreateCompanionBuilder,
      $$HrvReadingsTableUpdateCompanionBuilder,
      (
        HrvReading,
        BaseReferences<_$PhoenixDatabase, $HrvReadingsTable, HrvReading>,
      ),
      HrvReading,
      PrefetchHooks Function()
    >;
typedef $$Week0SessionsTableCreateCompanionBuilder =
    Week0SessionsCompanion Function({
      Value<int> id,
      required int sessionNumber,
      required String focus,
      Value<DateTime?> completedAt,
      Value<double?> avgRpe,
      Value<bool> passed,
      Value<String> notes,
    });
typedef $$Week0SessionsTableUpdateCompanionBuilder =
    Week0SessionsCompanion Function({
      Value<int> id,
      Value<int> sessionNumber,
      Value<String> focus,
      Value<DateTime?> completedAt,
      Value<double?> avgRpe,
      Value<bool> passed,
      Value<String> notes,
    });

class $$Week0SessionsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $Week0SessionsTable> {
  $$Week0SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionNumber => $composableBuilder(
    column: $table.sessionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgRpe => $composableBuilder(
    column: $table.avgRpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$Week0SessionsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $Week0SessionsTable> {
  $$Week0SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionNumber => $composableBuilder(
    column: $table.sessionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focus => $composableBuilder(
    column: $table.focus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgRpe => $composableBuilder(
    column: $table.avgRpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$Week0SessionsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $Week0SessionsTable> {
  $$Week0SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sessionNumber => $composableBuilder(
    column: $table.sessionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get focus =>
      $composableBuilder(column: $table.focus, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgRpe =>
      $composableBuilder(column: $table.avgRpe, builder: (column) => column);

  GeneratedColumn<bool> get passed =>
      $composableBuilder(column: $table.passed, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$Week0SessionsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $Week0SessionsTable,
          Week0Session,
          $$Week0SessionsTableFilterComposer,
          $$Week0SessionsTableOrderingComposer,
          $$Week0SessionsTableAnnotationComposer,
          $$Week0SessionsTableCreateCompanionBuilder,
          $$Week0SessionsTableUpdateCompanionBuilder,
          (
            Week0Session,
            BaseReferences<
              _$PhoenixDatabase,
              $Week0SessionsTable,
              Week0Session
            >,
          ),
          Week0Session,
          PrefetchHooks Function()
        > {
  $$Week0SessionsTableTableManager(
    _$PhoenixDatabase db,
    $Week0SessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$Week0SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$Week0SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$Week0SessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionNumber = const Value.absent(),
                Value<String> focus = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<double?> avgRpe = const Value.absent(),
                Value<bool> passed = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => Week0SessionsCompanion(
                id: id,
                sessionNumber: sessionNumber,
                focus: focus,
                completedAt: completedAt,
                avgRpe: avgRpe,
                passed: passed,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionNumber,
                required String focus,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<double?> avgRpe = const Value.absent(),
                Value<bool> passed = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => Week0SessionsCompanion.insert(
                id: id,
                sessionNumber: sessionNumber,
                focus: focus,
                completedAt: completedAt,
                avgRpe: avgRpe,
                passed: passed,
                notes: notes,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$Week0SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $Week0SessionsTable,
      Week0Session,
      $$Week0SessionsTableFilterComposer,
      $$Week0SessionsTableOrderingComposer,
      $$Week0SessionsTableAnnotationComposer,
      $$Week0SessionsTableCreateCompanionBuilder,
      $$Week0SessionsTableUpdateCompanionBuilder,
      (
        Week0Session,
        BaseReferences<_$PhoenixDatabase, $Week0SessionsTable, Week0Session>,
      ),
      Week0Session,
      PrefetchHooks Function()
    >;
typedef $$RingDevicesTableCreateCompanionBuilder =
    RingDevicesCompanion Function({
      Value<int> id,
      required String macAddress,
      required String name,
      Value<String> firmwareVersion,
      Value<String> hardwareVersion,
      Value<String> capabilitiesJson,
      Value<DateTime?> lastSync,
      Value<int> batteryLevel,
      required DateTime pairedAt,
    });
typedef $$RingDevicesTableUpdateCompanionBuilder =
    RingDevicesCompanion Function({
      Value<int> id,
      Value<String> macAddress,
      Value<String> name,
      Value<String> firmwareVersion,
      Value<String> hardwareVersion,
      Value<String> capabilitiesJson,
      Value<DateTime?> lastSync,
      Value<int> batteryLevel,
      Value<DateTime> pairedAt,
    });

class $$RingDevicesTableFilterComposer
    extends Composer<_$PhoenixDatabase, $RingDevicesTable> {
  $$RingDevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firmwareVersion => $composableBuilder(
    column: $table.firmwareVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hardwareVersion => $composableBuilder(
    column: $table.hardwareVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get capabilitiesJson => $composableBuilder(
    column: $table.capabilitiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get batteryLevel => $composableBuilder(
    column: $table.batteryLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pairedAt => $composableBuilder(
    column: $table.pairedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RingDevicesTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $RingDevicesTable> {
  $$RingDevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firmwareVersion => $composableBuilder(
    column: $table.firmwareVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hardwareVersion => $composableBuilder(
    column: $table.hardwareVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get capabilitiesJson => $composableBuilder(
    column: $table.capabilitiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
    column: $table.lastSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get batteryLevel => $composableBuilder(
    column: $table.batteryLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pairedAt => $composableBuilder(
    column: $table.pairedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RingDevicesTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $RingDevicesTable> {
  $$RingDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get macAddress => $composableBuilder(
    column: $table.macAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get firmwareVersion => $composableBuilder(
    column: $table.firmwareVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hardwareVersion => $composableBuilder(
    column: $table.hardwareVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get capabilitiesJson => $composableBuilder(
    column: $table.capabilitiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  GeneratedColumn<int> get batteryLevel => $composableBuilder(
    column: $table.batteryLevel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pairedAt =>
      $composableBuilder(column: $table.pairedAt, builder: (column) => column);
}

class $$RingDevicesTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $RingDevicesTable,
          RingDevice,
          $$RingDevicesTableFilterComposer,
          $$RingDevicesTableOrderingComposer,
          $$RingDevicesTableAnnotationComposer,
          $$RingDevicesTableCreateCompanionBuilder,
          $$RingDevicesTableUpdateCompanionBuilder,
          (
            RingDevice,
            BaseReferences<_$PhoenixDatabase, $RingDevicesTable, RingDevice>,
          ),
          RingDevice,
          PrefetchHooks Function()
        > {
  $$RingDevicesTableTableManager(_$PhoenixDatabase db, $RingDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RingDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RingDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$RingDevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> macAddress = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> firmwareVersion = const Value.absent(),
                Value<String> hardwareVersion = const Value.absent(),
                Value<String> capabilitiesJson = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> batteryLevel = const Value.absent(),
                Value<DateTime> pairedAt = const Value.absent(),
              }) => RingDevicesCompanion(
                id: id,
                macAddress: macAddress,
                name: name,
                firmwareVersion: firmwareVersion,
                hardwareVersion: hardwareVersion,
                capabilitiesJson: capabilitiesJson,
                lastSync: lastSync,
                batteryLevel: batteryLevel,
                pairedAt: pairedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String macAddress,
                required String name,
                Value<String> firmwareVersion = const Value.absent(),
                Value<String> hardwareVersion = const Value.absent(),
                Value<String> capabilitiesJson = const Value.absent(),
                Value<DateTime?> lastSync = const Value.absent(),
                Value<int> batteryLevel = const Value.absent(),
                required DateTime pairedAt,
              }) => RingDevicesCompanion.insert(
                id: id,
                macAddress: macAddress,
                name: name,
                firmwareVersion: firmwareVersion,
                hardwareVersion: hardwareVersion,
                capabilitiesJson: capabilitiesJson,
                lastSync: lastSync,
                batteryLevel: batteryLevel,
                pairedAt: pairedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RingDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $RingDevicesTable,
      RingDevice,
      $$RingDevicesTableFilterComposer,
      $$RingDevicesTableOrderingComposer,
      $$RingDevicesTableAnnotationComposer,
      $$RingDevicesTableCreateCompanionBuilder,
      $$RingDevicesTableUpdateCompanionBuilder,
      (
        RingDevice,
        BaseReferences<_$PhoenixDatabase, $RingDevicesTable, RingDevice>,
      ),
      RingDevice,
      PrefetchHooks Function()
    >;
typedef $$RingHrSamplesTableCreateCompanionBuilder =
    RingHrSamplesCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required int hr,
      required String source,
      Value<double?> quality,
    });
typedef $$RingHrSamplesTableUpdateCompanionBuilder =
    RingHrSamplesCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<int> hr,
      Value<String> source,
      Value<double?> quality,
    });

class $$RingHrSamplesTableFilterComposer
    extends Composer<_$PhoenixDatabase, $RingHrSamplesTable> {
  $$RingHrSamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hr => $composableBuilder(
    column: $table.hr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RingHrSamplesTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $RingHrSamplesTable> {
  $$RingHrSamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hr => $composableBuilder(
    column: $table.hr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RingHrSamplesTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $RingHrSamplesTable> {
  $$RingHrSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get hr =>
      $composableBuilder(column: $table.hr, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<double> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);
}

class $$RingHrSamplesTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $RingHrSamplesTable,
          RingHrSample,
          $$RingHrSamplesTableFilterComposer,
          $$RingHrSamplesTableOrderingComposer,
          $$RingHrSamplesTableAnnotationComposer,
          $$RingHrSamplesTableCreateCompanionBuilder,
          $$RingHrSamplesTableUpdateCompanionBuilder,
          (
            RingHrSample,
            BaseReferences<
              _$PhoenixDatabase,
              $RingHrSamplesTable,
              RingHrSample
            >,
          ),
          RingHrSample,
          PrefetchHooks Function()
        > {
  $$RingHrSamplesTableTableManager(
    _$PhoenixDatabase db,
    $RingHrSamplesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RingHrSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$RingHrSamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RingHrSamplesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> hr = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<double?> quality = const Value.absent(),
              }) => RingHrSamplesCompanion(
                id: id,
                timestamp: timestamp,
                hr: hr,
                source: source,
                quality: quality,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required int hr,
                required String source,
                Value<double?> quality = const Value.absent(),
              }) => RingHrSamplesCompanion.insert(
                id: id,
                timestamp: timestamp,
                hr: hr,
                source: source,
                quality: quality,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RingHrSamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $RingHrSamplesTable,
      RingHrSample,
      $$RingHrSamplesTableFilterComposer,
      $$RingHrSamplesTableOrderingComposer,
      $$RingHrSamplesTableAnnotationComposer,
      $$RingHrSamplesTableCreateCompanionBuilder,
      $$RingHrSamplesTableUpdateCompanionBuilder,
      (
        RingHrSample,
        BaseReferences<_$PhoenixDatabase, $RingHrSamplesTable, RingHrSample>,
      ),
      RingHrSample,
      PrefetchHooks Function()
    >;
typedef $$RingSleepStagesTableCreateCompanionBuilder =
    RingSleepStagesCompanion Function({
      Value<int> id,
      required DateTime nightDate,
      required String stage,
      required DateTime startTime,
      required DateTime endTime,
      Value<int?> hrAvg,
      Value<double?> tempAvg,
    });
typedef $$RingSleepStagesTableUpdateCompanionBuilder =
    RingSleepStagesCompanion Function({
      Value<int> id,
      Value<DateTime> nightDate,
      Value<String> stage,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<int?> hrAvg,
      Value<double?> tempAvg,
    });

class $$RingSleepStagesTableFilterComposer
    extends Composer<_$PhoenixDatabase, $RingSleepStagesTable> {
  $$RingSleepStagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nightDate => $composableBuilder(
    column: $table.nightDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrAvg => $composableBuilder(
    column: $table.hrAvg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tempAvg => $composableBuilder(
    column: $table.tempAvg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RingSleepStagesTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $RingSleepStagesTable> {
  $$RingSleepStagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nightDate => $composableBuilder(
    column: $table.nightDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrAvg => $composableBuilder(
    column: $table.hrAvg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tempAvg => $composableBuilder(
    column: $table.tempAvg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RingSleepStagesTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $RingSleepStagesTable> {
  $$RingSleepStagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get nightDate =>
      $composableBuilder(column: $table.nightDate, builder: (column) => column);

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get hrAvg =>
      $composableBuilder(column: $table.hrAvg, builder: (column) => column);

  GeneratedColumn<double> get tempAvg =>
      $composableBuilder(column: $table.tempAvg, builder: (column) => column);
}

class $$RingSleepStagesTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $RingSleepStagesTable,
          RingSleepStage,
          $$RingSleepStagesTableFilterComposer,
          $$RingSleepStagesTableOrderingComposer,
          $$RingSleepStagesTableAnnotationComposer,
          $$RingSleepStagesTableCreateCompanionBuilder,
          $$RingSleepStagesTableUpdateCompanionBuilder,
          (
            RingSleepStage,
            BaseReferences<
              _$PhoenixDatabase,
              $RingSleepStagesTable,
              RingSleepStage
            >,
          ),
          RingSleepStage,
          PrefetchHooks Function()
        > {
  $$RingSleepStagesTableTableManager(
    _$PhoenixDatabase db,
    $RingSleepStagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$RingSleepStagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RingSleepStagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$RingSleepStagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> nightDate = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<int?> hrAvg = const Value.absent(),
                Value<double?> tempAvg = const Value.absent(),
              }) => RingSleepStagesCompanion(
                id: id,
                nightDate: nightDate,
                stage: stage,
                startTime: startTime,
                endTime: endTime,
                hrAvg: hrAvg,
                tempAvg: tempAvg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime nightDate,
                required String stage,
                required DateTime startTime,
                required DateTime endTime,
                Value<int?> hrAvg = const Value.absent(),
                Value<double?> tempAvg = const Value.absent(),
              }) => RingSleepStagesCompanion.insert(
                id: id,
                nightDate: nightDate,
                stage: stage,
                startTime: startTime,
                endTime: endTime,
                hrAvg: hrAvg,
                tempAvg: tempAvg,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RingSleepStagesTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $RingSleepStagesTable,
      RingSleepStage,
      $$RingSleepStagesTableFilterComposer,
      $$RingSleepStagesTableOrderingComposer,
      $$RingSleepStagesTableAnnotationComposer,
      $$RingSleepStagesTableCreateCompanionBuilder,
      $$RingSleepStagesTableUpdateCompanionBuilder,
      (
        RingSleepStage,
        BaseReferences<
          _$PhoenixDatabase,
          $RingSleepStagesTable,
          RingSleepStage
        >,
      ),
      RingSleepStage,
      PrefetchHooks Function()
    >;
typedef $$RingStepsTableCreateCompanionBuilder =
    RingStepsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required int steps,
      required int calories,
      required int distanceM,
    });
typedef $$RingStepsTableUpdateCompanionBuilder =
    RingStepsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<int> steps,
      Value<int> calories,
      Value<int> distanceM,
    });

class $$RingStepsTableFilterComposer
    extends Composer<_$PhoenixDatabase, $RingStepsTable> {
  $$RingStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RingStepsTableOrderingComposer
    extends Composer<_$PhoenixDatabase, $RingStepsTable> {
  $$RingStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RingStepsTableAnnotationComposer
    extends Composer<_$PhoenixDatabase, $RingStepsTable> {
  $$RingStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<int> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);
}

class $$RingStepsTableTableManager
    extends
        RootTableManager<
          _$PhoenixDatabase,
          $RingStepsTable,
          RingStep,
          $$RingStepsTableFilterComposer,
          $$RingStepsTableOrderingComposer,
          $$RingStepsTableAnnotationComposer,
          $$RingStepsTableCreateCompanionBuilder,
          $$RingStepsTableUpdateCompanionBuilder,
          (
            RingStep,
            BaseReferences<_$PhoenixDatabase, $RingStepsTable, RingStep>,
          ),
          RingStep,
          PrefetchHooks Function()
        > {
  $$RingStepsTableTableManager(_$PhoenixDatabase db, $RingStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RingStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RingStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RingStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> distanceM = const Value.absent(),
              }) => RingStepsCompanion(
                id: id,
                timestamp: timestamp,
                steps: steps,
                calories: calories,
                distanceM: distanceM,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required int steps,
                required int calories,
                required int distanceM,
              }) => RingStepsCompanion.insert(
                id: id,
                timestamp: timestamp,
                steps: steps,
                calories: calories,
                distanceM: distanceM,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RingStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$PhoenixDatabase,
      $RingStepsTable,
      RingStep,
      $$RingStepsTableFilterComposer,
      $$RingStepsTableOrderingComposer,
      $$RingStepsTableAnnotationComposer,
      $$RingStepsTableCreateCompanionBuilder,
      $$RingStepsTableUpdateCompanionBuilder,
      (RingStep, BaseReferences<_$PhoenixDatabase, $RingStepsTable, RingStep>),
      RingStep,
      PrefetchHooks Function()
    >;

class $PhoenixDatabaseManager {
  final _$PhoenixDatabase _db;
  $PhoenixDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$FastingSessionsTableTableManager get fastingSessions =>
      $$FastingSessionsTableTableManager(_db, _db.fastingSessions);
  $$BiomarkersTableTableManager get biomarkers =>
      $$BiomarkersTableTableManager(_db, _db.biomarkers);
  $$ConditioningSessionsTableTableManager get conditioningSessions =>
      $$ConditioningSessionsTableTableManager(_db, _db.conditioningSessions);
  $$LlmReportsTableTableManager get llmReports =>
      $$LlmReportsTableTableManager(_db, _db.llmReports);
  $$ProgressionHistoryTableTableManager get progressionHistory =>
      $$ProgressionHistoryTableTableManager(_db, _db.progressionHistory);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$MealLogsTableTableManager get mealLogs =>
      $$MealLogsTableTableManager(_db, _db.mealLogs);
  $$FoodItemsTableTableManager get foodItems =>
      $$FoodItemsTableTableManager(_db, _db.foodItems);
  $$MealTemplatesTableTableManager get mealTemplates =>
      $$MealTemplatesTableTableManager(_db, _db.mealTemplates);
  $$AssessmentsTableTableManager get assessments =>
      $$AssessmentsTableTableManager(_db, _db.assessments);
  $$ResearchFeedTableTableManager get researchFeed =>
      $$ResearchFeedTableTableManager(_db, _db.researchFeed);
  $$CardioSessionsTableTableManager get cardioSessions =>
      $$CardioSessionsTableTableManager(_db, _db.cardioSessions);
  $$MesocycleStatesTableTableManager get mesocycleStates =>
      $$MesocycleStatesTableTableManager(_db, _db.mesocycleStates);
  $$MesocycleExercisesTableTableManager get mesocycleExercises =>
      $$MesocycleExercisesTableTableManager(_db, _db.mesocycleExercises);
  $$HrvReadingsTableTableManager get hrvReadings =>
      $$HrvReadingsTableTableManager(_db, _db.hrvReadings);
  $$Week0SessionsTableTableManager get week0Sessions =>
      $$Week0SessionsTableTableManager(_db, _db.week0Sessions);
  $$RingDevicesTableTableManager get ringDevices =>
      $$RingDevicesTableTableManager(_db, _db.ringDevices);
  $$RingHrSamplesTableTableManager get ringHrSamples =>
      $$RingHrSamplesTableTableManager(_db, _db.ringHrSamples);
  $$RingSleepStagesTableTableManager get ringSleepStages =>
      $$RingSleepStagesTableTableManager(_db, _db.ringSleepStages);
  $$RingStepsTableTableManager get ringSteps =>
      $$RingStepsTableTableManager(_db, _db.ringSteps);
}
