import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/receipts_provider.dart';
import '../../../data/providers/terminals_provider.dart';

class ReceiptFilter extends StatefulWidget {
  final ReceiptQuery initialQuery;
  final Function(ReceiptQuery query) onFilterChanged;

  const ReceiptFilter({
    super.key,
    required this.initialQuery,
    required this.onFilterChanged,
  });

  @override
  State<ReceiptFilter> createState() => _ReceiptFilterState();
}

class _ReceiptFilterState extends State<ReceiptFilter> with TickerProviderStateMixin {
  static const double filterBoxWidth = 110;
  static const double filterBoxHeight = 36;

  String? _idValue;
  String? _amountFrom;
  String? _amountTo;

  Set<String> _selectedShops = {};
  Set<String> _selectedTerminals = {};
  Set<String> _selectedStatuses = {};
  Set<String> _selectedTransactionTypes = {};
  Set<String> _selectedPaymentTypes = {};

  DateTimeRange? _dateRange;

  late final List<String> _allShops;
  late List<String> _allTerminals;
  final List<String> _allStatuses = [
    'Не обработан',
    'Обрабатывается',
    'Обработан',
    'Ошибки обработки',
    'Истек срок обработки',
  ];
  final List<String> _allTransactionTypes = [
    'Приход',
    'Возврат прихода',
    'Расход',
    'Возврат расхода',
  ];
  final List<String> _allPaymentTypes = [
    'Наличные',
    'Безналичные',
  ];

  bool _collapsed = false;
  bool _filtersChanged = false;

  @override
  void initState() {
    super.initState();
    _allShops = List.generate(37, (i) => 'C${i + 1}');
    _allTerminals = [];

    final query = widget.initialQuery;
    _idValue = query.containsId;
    _amountFrom = query.amountRange != null && query.amountRange!.start > 0 ? query.amountRange!.start.toString() : null;
    _amountTo = query.amountRange != null && query.amountRange!.end < double.infinity ? query.amountRange!.end.toString() : null;
    _selectedShops = query.shops ?? _allShops.toSet();
    _selectedTerminals = query.terminals ?? {};
    _dateRange = query.dateRange ??
        DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month, 1),
          end: DateTime.now(),
        );
    _selectedStatuses = query.statuses ?? _allStatuses.toSet();
    _selectedTransactionTypes = query.transactionTypes ?? _allTransactionTypes.toSet();
    _selectedPaymentTypes = query.paymentTypes ?? _allPaymentTypes.toSet();
  }

  void _updateTerminals(List<String> terminals) {
    _allTerminals = terminals;
    if (_selectedTerminals.isEmpty) {
      setState(() {
        _selectedTerminals = _allTerminals.toSet();
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _idValue = null;
      _amountFrom = null;
      _amountTo = null;
      _selectedShops = {};
      _selectedTerminals = {};
      _selectedStatuses = {};
      _selectedTransactionTypes = {};
      _selectedPaymentTypes = {};
      _dateRange = DateTimeRange(
        start: DateTime(DateTime.now().year, DateTime.now().month, 1),
        end: DateTime.now(),
      );
      _filtersChanged = true;
    });
  }

  void _applyFilters() {
    double? amountFrom = double.tryParse(_amountFrom ?? '');
    double? amountTo = double.tryParse(_amountTo ?? '');

    widget.onFilterChanged(
      ReceiptQuery(
        containsId: (_idValue == null || _idValue!.isEmpty) ? null : _idValue,
        shops: _selectedShops,
        terminals: _selectedTerminals,
        dateRange: _dateRange,
        amountRange: (amountFrom != null || amountTo != null)
            ? RangeValues(
                amountFrom ?? 0,
                amountTo ?? double.infinity,
              )
            : null,
        statuses: _selectedStatuses,
        transactionTypes: _selectedTransactionTypes,
        paymentTypes: _selectedPaymentTypes,
      ),
    );
    setState(() {
      _filtersChanged = false;
    });
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_idValue != null && _idValue!.isNotEmpty) count++;
    if (_selectedShops.isNotEmpty) count++;
    if (_selectedTerminals.isNotEmpty) count++;
    if (_amountFrom != null && _amountFrom!.isNotEmpty) count++;
    if (_amountTo != null && _amountTo!.isNotEmpty) count++;
    if (_selectedStatuses.isNotEmpty) count++;
    if (_selectedTransactionTypes.isNotEmpty) count++;
    if (_selectedPaymentTypes.isNotEmpty) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final terminalsProvider = Provider.of<TerminalsProvider>(context);
    final terminals = terminalsProvider.terminals;

    if (_allTerminals.isEmpty && terminals.isNotEmpty) {
      _updateTerminals(terminals);
      if (_selectedTerminals.isEmpty) {
        _selectedTerminals = terminals.toSet();
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Card(
        elevation: 2,
        shadowColor: const Color(0x19000000), // alpha 25
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: const Color(0xFFF4F6FA),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_collapsed)
                    Row(
                      children: [
                        const Icon(Icons.filter_alt, color: Color(0xFF2563EB), size: 18),
                        const SizedBox(width: 2),
                        Text('Фильтры', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700], fontSize: 12)),
                        if (_activeFiltersCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_activeFiltersCount',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                      ],
                    ),
                  IconButton(
                    icon: Icon(_collapsed ? Icons.unfold_more : Icons.unfold_less, size: 18),
                    tooltip: _collapsed ? 'Показать фильтры' : 'Свернуть фильтры',
                    onPressed: () => setState(() => _collapsed = !_collapsed),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _collapsed
                    ? const SizedBox(height: 0)
                    : SizedBox(
                        height: filterBoxHeight + 6,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _FilterButton(
                                icon: Icons.search,
                                label: 'ID',
                                value: _idValue,
                                placeholder: 'Поиск',
                                placeholderColor: Colors.grey,
                                onTap: () async {
                                  final result = await showAnimatedDialog<String>(
                                    context,
                                    _buildTextDialog(
                                      context,
                                      icon: Icons.search,
                                      title: 'ID чека',
                                      hint: 'Введите ID',
                                      value: _idValue,
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      _idValue = result.isEmpty ? null : result;
                                      _filtersChanged = true;
                                    });
                                  }
                                },
                                onClear: _idValue != null && _idValue!.isNotEmpty
                                    ? () => setState(() {
                                          _idValue = null;
                                          _filtersChanged = true;
                                        })
                                    : null,
                                isActive: _idValue != null && _idValue!.isNotEmpty,
                              ),
                              const _MiniSpace(),
                              _MultiSelectButton(
                                icon: Icons.store,
                                label: 'Склад',
                                options: _allShops,
                                selected: _selectedShops,
                                onSelectionChanged: (set) {
                                  setState(() {
                                    _selectedShops = set;
                                    _filtersChanged = true;
                                  });
                                },
                                showAllDark: _selectedShops.length == _allShops.length,
                                showNoneRed: _selectedShops.isEmpty,
                                onClear: _selectedShops.isNotEmpty
                                    ? () => setState(() {
                                          _selectedShops = {};
                                          _filtersChanged = true;
                                        })
                                    : null,
                              ),
                              const _MiniSpace(),
                              _MultiSelectButton(
                                icon: Icons.dns,
                                label: 'Терм.',
                                options: terminals,
                                selected: _selectedTerminals,
                                onSelectionChanged: (set) {
                                  setState(() {
                                    _selectedTerminals = set;
                                    _filtersChanged = true;
                                  });
                                },
                                showAllDark: _selectedTerminals.length == terminals.length,
                                showNoneRed: _selectedTerminals.isEmpty,
                                onClear: _selectedTerminals.isNotEmpty
                                    ? () => setState(() {
                                          _selectedTerminals = {};
                                          _filtersChanged = true;
                                        })
                                    : null,
                              ),
                              const _MiniSpace(),
                              _FilterButton(
                                icon: Icons.calendar_today,
                                label: 'Даты',
                                value: _dateRange == null
                                    ? null
                                    : '${DateFormat('dd.MM').format(_dateRange!.start)}-${DateFormat('dd.MM').format(_dateRange!.end)}',
                                placeholder: '',
                                onTap: () async {
                                  final picked = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                    initialDateRange: _dateRange,
                                    locale: const Locale('ru', 'RU'),
                                    builder: (context, child) => Dialog(
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 600),
                                        child: child,
                                      ),
                                    ),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _dateRange = picked;
                                      _filtersChanged = true;
                                    });
                                  }
                                },
                                onClear: null,
                                isActive: false,
                              ),
                              const _MiniSpace(),
                              _FilterButton(
                                icon: Icons.currency_ruble,
                                label: 'От',
                                value: _amountFrom,
                                placeholder: 'Нет',
                                placeholderColor: Colors.red,
                                onTap: () async {
                                  final result = await showAnimatedDialog<String>(
                                    context,
                                    _buildTextDialog(
                                      context,
                                      icon: Icons.currency_ruble,
                                      title: 'Сумма от',
                                      hint: 'Введите сумму от',
                                      value: _amountFrom,
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      _amountFrom = result.isEmpty ? null : result;
                                      _filtersChanged = true;
                                    });
                                  }
                                },
                                onClear: _amountFrom != null && _amountFrom!.isNotEmpty
                                    ? () => setState(() {
                                          _amountFrom = null;
                                          _filtersChanged = true;
                                        })
                                    : null,
                                isActive: _amountFrom != null && _amountFrom!.isNotEmpty,
                              ),
                              const _MiniSpace(),
                              _FilterButton(
                                icon: Icons.currency_ruble,
                                label: 'До',
                                value: _amountTo,
                                placeholder: 'Нет',
                                placeholderColor: Colors.red,
                                onTap: () async {
                                  final result = await showAnimatedDialog<String>(
                                    context,
                                    _buildTextDialog(
                                      context,
                                      icon: Icons.currency_ruble,
                                      title: 'Сумма до',
                                      hint: 'Введите сумму до',
                                      value: _amountTo,
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      _amountTo = result.isEmpty ? null : result;
                                      _filtersChanged = true;
                                    });
                                  }
                                },
                                onClear: _amountTo != null && _amountTo!.isNotEmpty
                                    ? () => setState(() {
                                          _amountTo = null;
                                          _filtersChanged = true;
                                        })
                                    : null,
                                isActive: _amountTo != null && _amountTo!.isNotEmpty,
                              ),
                              const _MiniSpace(),
                              _MultiSelectButton(
                                icon: Icons.filter_alt,
                                label: 'Статус',
                                options: _allStatuses,
                                selected: _selectedStatuses,
                                onSelectionChanged: (set) {
                                  setState(() {
                                    _selectedStatuses = set;
                                    _filtersChanged = true;
                                  });
                                },
                                showAllDark: _selectedStatuses.length == _allStatuses.length,
                                showNoneRed: _selectedStatuses.isEmpty,
                                onClear: _selectedStatuses.isNotEmpty
                                    ? () => setState(() {
                                          _selectedStatuses = {};
                                          _filtersChanged = true;
                                        })
                                    : null,
                              ),
                              const _MiniSpace(),
                              _MultiSelectButton(
                                icon: Icons.filter_alt,
                                label: 'Призн.',
                                options: _allTransactionTypes,
                                selected: _selectedTransactionTypes,
                                onSelectionChanged: (set) {
                                  setState(() {
                                    _selectedTransactionTypes = set;
                                    _filtersChanged = true;
                                  });
                                },
                                showAllDark: _selectedTransactionTypes.length == _allTransactionTypes.length,
                                showNoneRed: _selectedTransactionTypes.isEmpty,
                                onClear: _selectedTransactionTypes.isNotEmpty
                                    ? () => setState(() {
                                          _selectedTransactionTypes = {};
                                          _filtersChanged = true;
                                        })
                                    : null,
                              ),
                              const _MiniSpace(),
                              _MultiSelectButton(
                                icon: Icons.payment,
                                label: 'Оплата',
                                options: _allPaymentTypes,
                                selected: _selectedPaymentTypes,
                                onSelectionChanged: (set) {
                                  setState(() {
                                    _selectedPaymentTypes = set;
                                    _filtersChanged = true;
                                  });
                                },
                                showAllDark: _selectedPaymentTypes.length == _allPaymentTypes.length,
                                showNoneRed: _selectedPaymentTypes.isEmpty,
                                onClear: _selectedPaymentTypes.isNotEmpty
                                    ? () => setState(() {
                                          _selectedPaymentTypes = {};
                                          _filtersChanged = true;
                                        })
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              if (!_collapsed)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _filtersChanged ? _resetFilters : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red[700],
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        child: const Text('Сбросить'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Применить'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        ),
                        onPressed: _filtersChanged ? _applyFilters : null,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniSpace extends StatelessWidget {
  const _MiniSpace();
  @override
  Widget build(BuildContext context) => const SizedBox(width: 5);
}

// --- Анимация появления диалога ---
Future<T?> showAnimatedDialog<T>(BuildContext context, Widget child) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return ScaleTransition(
        scale: curved,
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

// --- Универсальный диалог для ввода текста ---
Widget _buildTextDialog(BuildContext context,
    {required IconData icon, required String title, required String hint, String? value}) {
  String temp = value ?? '';
  final controller = TextEditingController(text: value ?? '');
  return AlertDialog(
    title: Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 8),
        Text(title),
      ],
    ),
    content: TextField(
      autofocus: true,
      decoration: InputDecoration(hintText: hint),
      keyboardType: TextInputType.text,
      onChanged: (val) => temp = val,
      controller: controller,
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, value),
        child: const Text('Отмена'),
      ),
      ElevatedButton(
        onPressed: () => Navigator.pop(context, temp),
        child: const Text('ОК'),
      ),
    ],
  );
}

// --- Кнопка-фильтр с иконкой, цветом, сбросом ---
class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final String? placeholder;
  final Color? placeholderColor;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final bool isActive;

  static const double width = _ReceiptFilterState.filterBoxWidth;
  static const double height = _ReceiptFilterState.filterBoxHeight;

  const _FilterButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.placeholder,
    this.placeholderColor,
    this.onClear,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final showValue = value != null && value!.isNotEmpty;
    final bgColor = isActive ? const Color(0xFFE3EDFB) : Colors.white;
    final borderColor = isActive ? const Color(0xFF2563EB) : Colors.grey.shade300;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 12),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isActive ? const Color(0xFF2563EB) : Colors.grey),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                showValue ? value! : (placeholder ?? 'Все'),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: showValue ? Colors.black : (placeholderColor ?? Colors.grey),
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (onClear != null)
              const Icon(Icons.clear, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// --- Кнопка мультивыбора с иконкой, цветом, сбросом ---
class _MultiSelectButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onSelectionChanged;
  final bool showAllDark;
  final bool showNoneRed;
  final VoidCallback? onClear;

  static const double width = _ReceiptFilterState.filterBoxWidth;
  static const double height = _ReceiptFilterState.filterBoxHeight;

  const _MultiSelectButton({
    required this.icon,
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelectionChanged,
    this.showAllDark = false,
    this.showNoneRed = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    String display;
    Color color;
    FontWeight weight = FontWeight.w600;

    if (showNoneRed) {
      display = 'Нет';
      color = Colors.red;
      weight = FontWeight.w600;
    } else if (showAllDark) {
      display = 'Все';
      color = Colors.black;
      weight = FontWeight.w700;
    } else if (selected.isEmpty) {
      display = 'Все';
      color = Colors.grey;
      weight = FontWeight.w600;
    } else {
      display = 'Выбрано: ${selected.length}';
      color = Colors.black;
      weight = FontWeight.w600;
    }

    final isActive = !showNoneRed && !showAllDark && selected.isNotEmpty;

    final bgColor = isActive ? const Color(0xFFE3EDFB) : Colors.white;
    final borderColor = isActive ? const Color(0xFF2563EB) : Colors.grey.shade300;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: () async {
          final tempSelected = Set<String>.from(selected);
          final result = await showAnimatedDialog<Set<String>>(
            context,
            StatefulBuilder(
              builder: (context, setStateDialog) => AlertDialog(
                title: Row(
                  children: [
                    Icon(icon, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                ),
                content: SizedBox(
                  width: 260,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setStateDialog(() {
                              if (tempSelected.length == options.length) {
                                tempSelected.clear();
                              } else {
                                tempSelected.clear();
                                tempSelected.addAll(options);
                              }
                            });
                          },
                          child: Text(
                            tempSelected.length == options.length
                                ? 'Снять все'
                                : 'Выбрать все',
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: options.map((option) {
                            return CheckboxListTile(
                              title: Text(option),
                              value: tempSelected.contains(option),
                              onChanged: (checked) {
                                setStateDialog(() {
                                  if (checked == true) {
                                    tempSelected.add(option);
                                  } else {
                                    tempSelected.remove(option);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, selected),
                    child: const Text('Отмена'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, tempSelected),
                    child: const Text('ОК'),
                  ),
                ],
              ),
            ),
          );
          if (result != null) {
            onSelectionChanged(result);
          }
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 12),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isActive ? const Color(0xFF2563EB) : Colors.grey),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                display,
                style: TextStyle(
                  fontWeight: weight,
                  color: color,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (onClear != null)
              const Icon(Icons.clear, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
