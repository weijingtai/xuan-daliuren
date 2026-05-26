enum SchoolAvailabilityStatus {
  available,
  planned,
}

class SchoolCatalogEntry {
  final String id;
  final String displayName;
  final String shortName;
  final String representativeBook;
  final String era;
  final String description;
  final List<String> tags;
  final SchoolAvailabilityStatus status;
  final int displayOrder;

  const SchoolCatalogEntry({
    required this.id,
    required this.displayName,
    required this.shortName,
    required this.representativeBook,
    required this.era,
    required this.description,
    required this.tags,
    required this.status,
    required this.displayOrder,
  });
}

class SchoolCatalog {
  static const List<SchoolCatalogEntry> all = [
    SchoolCatalogEntry(
      id: 'yuding',
      displayName: '御定大六壬',
      shortName: '御定',
      representativeBook: '《御定大六壬直指》',
      era: '清代',
      description: '清代宫廷编撰的官方大六壬体系，当前作为默认解释流派。',
      tags: ['官方', '权威', '默认'],
      status: SchoolAvailabilityStatus.available,
      displayOrder: 1,
    ),
    SchoolCatalogEntry(
      id: 'bifa',
      displayName: '毕法赋',
      shortName: '毕法赋',
      representativeBook: '《毕法赋》',
      era: '宋代',
      description: '以歌诀形式总结占断要诀，共一百条法则，便于学习和快速查用。',
      tags: ['法则', '歌诀', '入门'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 2,
    ),
    SchoolCatalogEntry(
      id: 'zhinan',
      displayName: '大六壬指南',
      shortName: '指南',
      representativeBook: '《大六壬指南》',
      era: '明代',
      description: '注重实际占验案例，强调活法和实证应用。',
      tags: ['案例', '实证', '活法'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 3,
    ),
    SchoolCatalogEntry(
      id: 'kejing',
      displayName: '大六壬课经',
      shortName: '课经',
      representativeBook: '《大六壬课经》',
      era: '明代',
      description: '以课体分类为核心，适合结构化理解课格和吉凶走向。',
      tags: ['课体', '分类', '结构'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 4,
    ),
    SchoolCatalogEntry(
      id: 'daliuren_daquan',
      displayName: '大六壬大全',
      shortName: '大全',
      representativeBook: '《大六壬大全》',
      era: '明代',
      description: '集成诸家之说，内容全面，适合后续作为综合资料库扩展。',
      tags: ['集成', '全面', '资料'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 5,
    ),
    SchoolCatalogEntry(
      id: 'rengui',
      displayName: '壬归',
      shortName: '壬归',
      representativeBook: '《壬归》',
      era: '清代',
      description: '按事项分类组织占法，贴近用户具体问题场景。',
      tags: ['事项', '分类', '实用'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 6,
    ),
    SchoolCatalogEntry(
      id: 'liuren_cuiyan',
      displayName: '六壬粹言',
      shortName: '粹言',
      representativeBook: '《六壬粹言》',
      era: '清代',
      description: '精选诸家精华，偏向进阶用户的精要参考。',
      tags: ['精要', '进阶', '参考'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 7,
    ),
    SchoolCatalogEntry(
      id: 'guanlu_shenshu',
      displayName: '管辂神书',
      shortName: '管辂',
      representativeBook: '《管辂神书》',
      era: '三国',
      description: '保留古法风格，重视天将与神煞，后续作为古法体系扩展。',
      tags: ['古法', '天将', '神煞'],
      status: SchoolAvailabilityStatus.planned,
      displayOrder: 8,
    ),
  ];

  static SchoolCatalogEntry? byId(String id) {
    for (final entry in all) {
      if (entry.id == id) return entry;
    }
    return null;
  }
}
