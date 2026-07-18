class S {
  static String lang = 'en';

  static const _en = {
    'parentZone': 'Grown-Ups',
    'gatePrompt': 'Hold the button for 3 seconds to enter',
    'whyThis': 'Why this activity?',
    'sortSkill': 'Skill: sorting by color — early logic & categorization',
    'sortApproach':
        'Approach: Montessori self-correcting materials. Wrong placements gently bounce back; the material teaches, not a buzzer.',
    'sortHome':
        'Try at home: ask your child to sort the laundry into color piles!',
    'restaurantMode': 'Focus Session',
    'restaurantHint':
        'Set a session length. When time is up, the world says goodnight by itself. Only you can restart it.',
    'minutes15': '15 minutes',
    'minutes20': '20 minutes',
    'minutes30': '30 minutes',
    'stopSession': 'End session now',
    'report': 'This week',
    'reportLeaves': 'Activities completed',
    'reportSort': 'Color sorting rounds',
    'childName': "Child's name (optional, stays on this device)",
    'ageBand': 'Age',
    'save': 'Save',
    'goodnight': 'The world is sleeping now.\nSee you next time!',
    'realmHome': 'Home & Family',
    'realmTown': 'Town',
    'realmNature': 'Nature Island',
    'realmSpace': 'Space Port',
    'chooseRealm': 'Choose a realm',
    'unlockTitle': 'Unlock this realm',
    'unlockBody':
        'This pack adds new levels, a new game, and a new companion. One-time purchase, no ads, no subscription needed.',
    'unlockPrice': 'Unlock — \$1.99',
    'comingSoon': 'Coming soon',
    'cancel': 'Not now',
    'matchSkill': 'Skill: memory & matching — working memory',
    'matchApproach':
        'Approach: HighScope plan-do-review. The child chooses which cards to flip; no timer pressure.',
    'matchHome': 'Try at home: a simple pairs card game after dinner!',
    'searchSkill': 'Skill: visual scanning & vocabulary',
    'searchApproach':
        'Approach: Reggio-style provocation — a rich scene to explore at the child\'s own pace, naming what they find.',
    'searchHome': 'Try at home: "I spy" on a walk outside!',
  };

  static const _es = {
    'parentZone': 'Adultos',
    'gatePrompt': 'Mantén pulsado el botón 3 segundos para entrar',
    'whyThis': '¿Por qué esta actividad?',
    'sortSkill': 'Habilidad: clasificar por color — lógica temprana',
    'sortApproach':
        'Enfoque: materiales Montessori autocorrectivos. Los errores rebotan suavemente; el material enseña, no un zumbador.',
    'sortHome':
        'En casa: ¡pide a tu hijo/a que separe la ropa por colores!',
    'restaurantMode': 'Sesión Tranquila',
    'restaurantHint':
        'Elige la duración. Al terminar, el mundo se despide solo. Solo tú puedes reiniciarla.',
    'minutes15': '15 minutos',
    'minutes20': '20 minutos',
    'minutes30': '30 minutos',
    'stopSession': 'Terminar ahora',
    'report': 'Esta semana',
    'reportLeaves': 'Actividades completadas',
    'reportSort': 'Rondas de clasificación',
    'childName': 'Nombre (opcional, se queda en este dispositivo)',
    'ageBand': 'Edad',
    'save': 'Guardar',
    'goodnight': 'El mundo está durmiendo.\n¡Hasta la próxima!',
    'realmHome': 'Hogar y Familia',
    'realmTown': 'Pueblo',
    'realmNature': 'Isla Natural',
    'realmSpace': 'Puerto Espacial',
    'chooseRealm': 'Elige un reino',
    'unlockTitle': 'Desbloquea este reino',
    'unlockBody':
        'Este paquete añade niveles nuevos, un juego nuevo y un compañero nuevo. Compra única, sin anuncios ni suscripción.',
    'unlockPrice': 'Desbloquear — \$1.99',
    'comingSoon': 'Próximamente',
    'cancel': 'Ahora no',
    'matchSkill': 'Habilidad: memoria y emparejamiento',
    'matchApproach':
        'Enfoque: HighScope planificar-hacer-revisar. El niño elige qué cartas voltear; sin presión de tiempo.',
    'matchHome': '¡Prueba en casa un juego de memoria después de cenar!',
    'searchSkill': 'Habilidad: exploración visual y vocabulario',
    'searchApproach':
        'Enfoque: provocación estilo Reggio — una escena rica para explorar a su propio ritmo.',
    'searchHome': '¡Prueba el juego "veo veo" en un paseo!',
  };

  static String t(String key) =>
      (lang == 'es' ? _es[key] : _en[key]) ?? _en[key] ?? key;
}
