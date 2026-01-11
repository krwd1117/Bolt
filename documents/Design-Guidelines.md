**1. Design Philosophy: "Thumb-Driven & Immersive"**

- **Touch-First (터치 우선):** 모든 상호작용 요소(버튼, 리스트 아이템)는 최소 **44x44pt(dp)** 이상의 터치 영역을 확보해야 한다.
    
- **Reachability (도달성):** 주요 액션 버튼(CTA)과 네비게이션은 화면 하단(Thumb Zone)에 배치한다. 상단 영역은 주로 '정보 표시(View)'에 집중한다.
    
- **Layered Depth (계층 구조):** 페이지 이동보다는 **Bottom Sheet(하단 모달)**를 적극 활용하여, 사용자가 문맥(Context)을 잃지 않고 작업을 수행하도록 한다.
    

**2. Layout & Navigation (Mobile Structure)**

- **Safe Area Compliance:** 노치(Notch)와 홈 인디케이터(Home Indicator) 영역을 침범하지 않도록 반드시 `SafeAreaView` 또는 동등한 패딩 처리를 한다.
    
- **Navigation Pattern:**
    - **Main:** 하단 'Bottom Tab Bar' (아이콘 + 선택 시 라벨 표시).
    - **Detail:** 'Stack Navigation' (오른쪽에서 왼쪽으로 슬라이드 진입).
    - **Action:** 'Modal / Bottom Sheet' (아래에서 위로 올라옴).
        
- **Fluid Header:** 스크롤 시 헤더가 축소되거나 배경이 블러(Blur) 처리되는 'Sticky Header' 효과를 적용한다.
    

**3. UI Components (Mobile Specific)**

- **Cards & Lists:**
    - 모바일에서는 카드 내부 패딩보다 **'화면 가로폭(Full Width)'**을 효율적으로 쓰는 것이 트렌드다.
    - 리스트 아이템 사이에는 얇은 구분선(`Separator`, 0.5dp)을 사용하거나, 그룹화된 카드(`Inset Group Style`)를 사용한다.
        
- **Buttons (CTA):**
    - 화면 하단에 고정된 **'Sticky Bottom Button'**을 자주 사용한다(키보드가 올라오면 키보드 바로 위로 이동).
    - 모서리는 `Rounded-Full`(완전 둥근 형태) 또는 `Rounded-16px`를 사용하여 부드러운 그립감을 준다.
        
- **Inputs:**
    - 입력창 터치 시 키보드가 UI를 가리지 않도록 `KeyboardAvoidingView` 처리를 필수적으로 한다.
    - 입력 필드는 높이를 넉넉하게(50pt 이상) 잡는다.

**4. Interactions & Gestures (The "Feel")**

- **Active State (Not Hover):** 모바일엔 호버(Hover)가 없다. 버튼을 **눌렀을 때(Pressed)** 즉각적으로 사이즈가 95%로 줄어들거나(`Scale Down`), 배경색이 어두워지는 피드백을 반드시 준다.
    
- **Haptic Feedback:**
    - 성공/완료: `Notification (Success)`
    - 버튼 탭/스위치: `Impact (Light/Medium)`
    - 오류: `Notification (Error)`
        
- **Gestures:**
    
    - "뒤로 가기" 버튼뿐만 아니라, 화면 왼쪽 가장자리를 스와이프(Swipe Back)하여 이전 화면으로 돌아가는 제스처를 지원해야 한다.
    - 리스트 아이템은 스와이프 액션(Swipeable)을 통해 삭제/보관 기능을 제공한다.

**5. Typography & Color (Adaptive)**

- **Dynamic Type Support:** 사용자가 시스템 글자 크기를 키웠을 때 레이아웃이 깨지지 않도록 폰트 크기는 고정값(px) 대신 상대값(rem, sp)이나 시스템 폰트 스케일을 따른다.
    
- **Dark Mode Ready:**
    - 배경: 순도 100% 검정(`Pure Black`, #000000)은 OLED 번인 방지와 배터리 효율을 위해 지양하고, 아주 어두운 회색(`#121212` or `#1C1C1E`)을 기본 배경으로 한다.
    - 텍스트: 흰색보다는 `#F2F2F7`(Off-White)을 사용하여 눈의 피로를 줄인다.

6. Code & Tech Context (Select One)
- **[Option A: React Native + Expo]**
    
    - Style: `NativeWind` (Tailwind style) 또는 `StyleSheet`.
        
    - Component: `Pressable`을 사용하여 커스텀 터치 피드백 구현.
        
    - Icons: `Expo Vector Icons` (Ionicons / Feather).
        
- **[Option B: Flutter]**
    
    - Style: `ThemeData`를 활용한 전역 스타일링.
        
    - Component: `InkWell` 또는 `GestureDetector`로 리플(Ripple) 효과 구현.
        
    - Layout: `SliverAppBar` 등을 활용한 스크롤 효과.
        

---
