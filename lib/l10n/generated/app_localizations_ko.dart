// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Bolt';

  @override
  String get noMemosFound => '메모가 없습니다';

  @override
  String get tapToAdd => '+ 버튼을 눌러 새 할 일을 추가하세요';

  @override
  String get todoHeader => '할 일';

  @override
  String get completedHeader => '완료됨';

  @override
  String get filterAll => '전체';

  @override
  String get filterToday => '오늘';

  @override
  String get filterUpcoming => '예정';

  @override
  String get filterOverdue => '지연';

  @override
  String get filterNoDate => '날짜 없음';

  @override
  String get filterClear => '필터 초기화';

  @override
  String get dateToday => '오늘';

  @override
  String get dateTomorrow => '내일';

  @override
  String dateInDays(int days) {
    return '$days일 후';
  }

  @override
  String dateDaysAgo(int days) {
    return '$days일 전';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get sectionNotionSync => 'Notion 동기화';

  @override
  String get sectionAccount => '계정';

  @override
  String get labelDatabase => '데이터베이스';

  @override
  String get msgSelectDatabase => '데이터베이스 선택';

  @override
  String get labelConfigureProperties => '속성 구성';

  @override
  String get btnConnectNotion => 'Notion 연결';

  @override
  String get btnLogout => '로그아웃';

  @override
  String get dialogLogoutTitle => '로그아웃';

  @override
  String get dialogLogoutContent => '정말 로그아웃 하시겠습니까?';

  @override
  String get dialogCancel => '취소';

  @override
  String get dialogLogoutAction => '로그아웃';

  @override
  String get msgLogoutSuccess => '성공적으로 로그아웃되었습니다';

  @override
  String get labelVersion => '버전';

  @override
  String get addTaskTitle => '새 할 일';

  @override
  String get addTaskHint => '새로운 작업을 입력하세요...';

  @override
  String get msgNoDatabaseSelected => '선택된 데이터베이스가 없습니다.';

  @override
  String get btnCreateTask => '할 일 생성';

  @override
  String get msgTaskAdded => 'Notion에 할 일이 추가되었습니다!';

  @override
  String msgTaskFailed(String error) {
    return '할 일 추가 실패: $error';
  }

  @override
  String get labelSelectDate => '날짜 선택';

  @override
  String get labelName => '이름';

  @override
  String get hintWhatNeedsToBeDone => '무엇을 해야 하나요?';

  @override
  String get labelType => '유형';

  @override
  String get labelNoType => '유형 없음';

  @override
  String get labelDueDate => '마감일';

  @override
  String get btnAdd => '추가';

  @override
  String get mappingTitle => '속성 매핑';

  @override
  String get mappingSubtitle => 'Bolt가 Notion 속성을 매핑하는 방식을 구성합니다';

  @override
  String get mappingSave => '저장';

  @override
  String get mappingSuccess => '매핑 저장됨';

  @override
  String get dbSelectionTitle => '데이터베이스 선택';

  @override
  String get dbSelectionEmpty => '접근 가능한 데이터베이스가 없습니다. Notion 통합 설정을 확인해주세요.';

  @override
  String msgDatabaseSelected(String database) {
    return '$database 선택됨';
  }

  @override
  String get tooltipRefresh => '속성 새로고침';

  @override
  String get msgFailedToLoadProperties => '속성을 불러오는데 실패했습니다';

  @override
  String get btnRetry => '재시도';

  @override
  String get sectionCoreProperties => '핵심 작업 속성';

  @override
  String get sectionAutomationProperties => '자동화 속성';

  @override
  String get btnSaveConfiguration => '구성 저장';

  @override
  String get msgConfigurationSaved => '구성이 저장되었습니다';

  @override
  String msgErrorLoadingProperties(String error) {
    return '속성 로드 오류: $error';
  }

  @override
  String get propTaskTitle => '작업 제목 (필수)';

  @override
  String get propStatus => '상태';

  @override
  String get propDueDate => '마감일';

  @override
  String get propType => '유형 / 카테고리';

  @override
  String get propName => '이름 (선택)';

  @override
  String get propDoneCheckbox => '완료 체크박스';

  @override
  String get propDoneDate => '완료 날짜';

  @override
  String get propCreatedDate => '생성 날짜';

  @override
  String get msgLaunchAuthUrlFailed => 'Notion 인증 URL을 열 수 없습니다';

  @override
  String msgError(String error) {
    return '오류: $error';
  }

  @override
  String get actionDelete => '삭제';

  @override
  String get actionUndo => '실행 취소';

  @override
  String get dialogDeleteTaskTitle => '할 일 삭제';

  @override
  String get dialogDeleteTaskContent => '이 할 일을 삭제하시겠습니까?';

  @override
  String get msgTaskDeleted => '할 일이 삭제되었습니다';

  @override
  String msgDeleteFailed(String error) {
    return '삭제 실패: $error';
  }
}
