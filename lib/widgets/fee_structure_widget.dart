import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:university_app_2/config/theme.dart';

// Fee Unit Enum
enum FeeUnit { perYear, perSemester, oneTime, perMonth }

// Fee Item Model
class FeeItem {
  String label;
  double amount;
  FeeUnit unit;
  int? semestersPerYear;
  int? monthsPerYear;
  int? applicableYear;
  bool isOptional;
  bool isRefundable;
  String? remarks;
  bool isEditable;

  FeeItem({
    required this.label,
    this.amount = 0,
    this.unit = FeeUnit.perYear,
    this.semestersPerYear,
    this.monthsPerYear,
    this.applicableYear = 1,
    this.isOptional = false,
    this.isRefundable = false,
    this.remarks,
    this.isEditable = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'amount': amount,
      'unit': unit.name.toUpperCase(),
      if (semestersPerYear != null) 'sem_per_year': semestersPerYear,
      if (monthsPerYear != null) 'months_per_year': monthsPerYear,
      if (applicableYear != null) 'applicable_year': applicableYear,
      'is_optional': isOptional,
      'refundable': isRefundable,
      if (remarks != null && remarks!.isNotEmpty) 'remarks': remarks,
    };
  }
}

class FeeStructureWidget extends StatefulWidget {
  final double durationYears;
  final Function(List<FeeItem>, double, int, int) onFeeStructureChanged;

  const FeeStructureWidget({
    Key? key,
    required this.durationYears,
    required this.onFeeStructureChanged,
  }) : super(key: key);

  @override
  State<FeeStructureWidget> createState() => _FeeStructureWidgetState();
}

class _FeeStructureWidgetState extends State<FeeStructureWidget> {
  late double _durationYears;
  int _semestersPerYear = 2;
  int _monthsPerYear = 10;

  late List<FeeItem> _feeItems;
  final List<FeeItem> _customFees = [];

  @override
  void initState() {
    super.initState();
    _durationYears = widget.durationYears > 0 ? widget.durationYears : 3.0;
    _initializeStandardFees();
  }

  void _initializeStandardFees() {
    _feeItems = [
      FeeItem(label: 'Tuition Fee', unit: FeeUnit.perYear, isEditable: false),
      FeeItem(label: 'Exam Fee', unit: FeeUnit.perYear, isEditable: false),
      FeeItem(
        label: 'Registration Fee',
        unit: FeeUnit.oneTime,
        isEditable: false,
      ),
      FeeItem(label: 'Admission Fee', unit: FeeUnit.oneTime, isEditable: false),
      FeeItem(label: 'Library Fee', unit: FeeUnit.perYear, isEditable: false),
      FeeItem(
        label: 'Lab / Clinical Fee',
        unit: FeeUnit.perYear,
        isEditable: false,
      ),
      FeeItem(
        label: 'Caution / Security',
        unit: FeeUnit.oneTime,
        isRefundable: true,
        isEditable: false,
      ),
      FeeItem(
        label: 'Hostel Fee',
        unit: FeeUnit.perMonth,
        isOptional: true,
        monthsPerYear: _monthsPerYear,
        isEditable: false,
      ),
      FeeItem(
        label: 'Mess / Meal Fee',
        unit: FeeUnit.perMonth,
        isOptional: true,
        monthsPerYear: _monthsPerYear,
        isEditable: false,
      ),
      FeeItem(
        label: 'Transport Fee',
        unit: FeeUnit.perMonth,
        isOptional: true,
        monthsPerYear: _monthsPerYear,
        isEditable: false,
      ),
    ];
  }

  void _notifyChanges() {
    final allFees = [..._feeItems, ..._customFees];
    widget.onFeeStructureChanged(
      allFees,
      _durationYears,
      _semestersPerYear,
      _monthsPerYear,
    );
  }

  Map<String, double> _calculateTotals() {
    final allFees = [..._feeItems, ..._customFees];
    double yAcad = 0, fAcad = 0, yOpt = 0, fOpt = 0;

    for (var f in allFees) {
      if (f.amount <= 0) continue;

      final sem = f.semestersPerYear ?? _semestersPerYear;
      final mon = f.monthsPerYear ?? _monthsPerYear;

      double yearly = 0, full = 0;
      switch (f.unit) {
        case FeeUnit.perYear:
          yearly = f.amount;
          full = f.amount * _durationYears;
          break;
        case FeeUnit.perSemester:
          yearly = f.amount * sem;
          full = f.amount * (_durationYears * sem);
          break;
        case FeeUnit.perMonth:
          yearly = f.amount * mon;
          full = f.amount * (_durationYears * mon);
          break;
        case FeeUnit.oneTime:
          yearly = 0;
          full = f.amount;
          break;
      }

      if (f.isOptional) {
        yOpt += yearly;
        fOpt += full;
      } else {
        yAcad += yearly;
        fAcad += full;
      }
    }

    return {
      'yAcad': yAcad,
      'fAcad': fAcad,
      'yOpt': yOpt,
      'fOpt': fOpt,
      'yGrand': yAcad + yOpt,
      'fGrand': fAcad + fOpt,
    };
  }

  String _formatCurrency(double amount) {
    return '₹${NumberFormat('#,##,##0').format(amount)}';
  }

  String _getUnitDisplay(FeeItem item) {
    switch (item.unit) {
      case FeeUnit.perYear:
        return '/year';
      case FeeUnit.perSemester:
        final sem = item.semestersPerYear ?? _semestersPerYear;
        return '/sem (×$sem)';
      case FeeUnit.perMonth:
        final mon = item.monthsPerYear ?? _monthsPerYear;
        return '/mo (×$mon)';
      case FeeUnit.oneTime:
        return 'one-time';
    }
  }

  @override
  Widget build(BuildContext context) {
    final totals = _calculateTotals();
    final hasRefundable = [
      ..._feeItems,
      ..._customFees,
    ].any((f) => f.isRefundable && f.amount > 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.currency_rupee, color: AppTheme.primaryBlue, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '2. Fee Structure',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Enter amounts & units; totals auto-calc',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Course Meta Fields
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Course Duration & Billing Meta',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _durationYears.toString(),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Duration (years)',
                        hintText: '3 or 4.5',
                        isDense: true,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (v) {
                        setState(() {
                          _durationYears = double.tryParse(v) ?? 3.0;
                          _notifyChanges();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      initialValue: _semestersPerYear.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Semesters/year',
                        hintText: '2',
                        isDense: true,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (v) {
                        setState(() {
                          _semestersPerYear = int.tryParse(v) ?? 2;
                          _notifyChanges();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      initialValue: _monthsPerYear.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Months billed/year',
                        hintText: '10',
                        isDense: true,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (v) {
                        setState(() {
                          _monthsPerYear = int.tryParse(v) ?? 10;
                          // Update existing month-based fees
                          for (var item in _feeItems) {
                            if (item.unit == FeeUnit.perMonth &&
                                item.monthsPerYear == null) {
                              item.monthsPerYear = _monthsPerYear;
                            }
                          }
                          _notifyChanges();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Fee Rows
        const Text(
          'Fee Items',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        ..._feeItems.asMap().entries.map((entry) {
          return _buildFeeRow(entry.value, entry.key, false);
        }).toList(),

        ..._customFees.asMap().entries.map((entry) {
          return _buildFeeRow(entry.value, entry.key, true);
        }).toList(),

        const SizedBox(height: 12),

        // Add Other Fee Button
        if (_customFees.length < 10)
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _customFees.add(
                  FeeItem(
                    label: 'Other Fee ${_customFees.length + 1}',
                    isEditable: true,
                  ),
                );
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              side: BorderSide(color: AppTheme.primaryBlue),
            ),
            icon: Icon(Icons.add, size: 18, color: AppTheme.primaryBlue),
            label: const Text('Add Other Fee', style: TextStyle(fontSize: 12)),
          ),

        const SizedBox(height: 20),

        // Totals Panel (Sticky)
        _buildTotalsPanel(totals, hasRefundable),
      ],
    );
  }

  Widget _buildFeeRow(FeeItem item, int index, bool isCustom) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.isOptional ? Colors.orange.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: item.isOptional
              ? Colors.orange.withOpacity(0.3)
              : Colors.grey[300]!,
          width: item.isOptional ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Label
              Expanded(
                flex: 2,
                child: item.isEditable
                    ? TextFormField(
                        initialValue: item.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Fee Label',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) {
                          setState(() => item.label = v);
                        },
                      )
                    : Row(
                        children: [
                          if (item.isOptional)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'OPT',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (item.isOptional) const SizedBox(width: 6),
                          if (item.isRefundable)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.success,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'REF',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (item.isRefundable) const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.label,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(width: 10),

              // Amount
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: item.amount > 0 ? item.amount.toString() : '',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: '0',
                    prefixText: '₹ ',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onChanged: (v) {
                    setState(() {
                      item.amount = double.tryParse(v) ?? 0;
                      _notifyChanges();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),

              // Unit Dropdown
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<FeeUnit>(
                  value: item.unit,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue.withOpacity(0.05),
                  ),
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                  items: const [
                    DropdownMenuItem(
                      value: FeeUnit.perYear,
                      child: Text('/year'),
                    ),
                    DropdownMenuItem(
                      value: FeeUnit.perSemester,
                      child: Text('/sem'),
                    ),
                    DropdownMenuItem(
                      value: FeeUnit.oneTime,
                      child: Text('one-time'),
                    ),
                    DropdownMenuItem(
                      value: FeeUnit.perMonth,
                      child: Text('/month'),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() {
                      item.unit = v!;
                      if (v == FeeUnit.perMonth && item.monthsPerYear == null) {
                        item.monthsPerYear = _monthsPerYear;
                      }
                      if (v == FeeUnit.perSemester &&
                          item.semestersPerYear == null) {
                        item.semestersPerYear = _semestersPerYear;
                      }
                      _notifyChanges();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),

              // Delete button for custom fees
              if (isCustom)
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() => _customFees.removeAt(index));
                    _notifyChanges();
                  },
                ),
            ],
          ),

          // Conditional Inputs based on Unit
          if (item.unit == FeeUnit.perSemester ||
              item.unit == FeeUnit.perMonth) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (item.unit == FeeUnit.perSemester)
                  Expanded(
                    child: TextFormField(
                      initialValue: (item.semestersPerYear ?? _semestersPerYear)
                          .toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Semesters/year',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) {
                        setState(() {
                          item.semestersPerYear =
                              int.tryParse(v) ?? _semestersPerYear;
                          _notifyChanges();
                        });
                      },
                    ),
                  ),
                if (item.unit == FeeUnit.perMonth)
                  Expanded(
                    child: TextFormField(
                      initialValue: (item.monthsPerYear ?? _monthsPerYear)
                          .toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Months/year',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) {
                        setState(() {
                          item.monthsPerYear =
                              int.tryParse(v) ?? _monthsPerYear;
                          _notifyChanges();
                        });
                      },
                    ),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getUnitDisplay(item),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (item.unit == FeeUnit.oneTime) ...[
            const SizedBox(height: 10),
            TextFormField(
              initialValue: (item.applicableYear ?? 1).toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Applicable Year',
                hintText: '1',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                setState(() {
                  item.applicableYear = int.tryParse(v) ?? 1;
                });
              },
            ),
          ],

          // Toggles & Remarks
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text(
                    'Optional Fee',
                    style: TextStyle(fontSize: 11),
                  ),
                  value: item.isOptional,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.orange,
                  onChanged: (v) {
                    setState(() {
                      item.isOptional = v ?? false;
                      _notifyChanges();
                    });
                  },
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text(
                    'Refundable',
                    style: TextStyle(fontSize: 11),
                  ),
                  value: item.isRefundable,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppTheme.success,
                  onChanged: (v) {
                    setState(() {
                      item.isRefundable = v ?? false;
                    });
                  },
                ),
              ),
            ],
          ),

          TextFormField(
            initialValue: item.remarks,
            decoration: const InputDecoration(
              hintText: 'Remarks (optional)',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(),
            ),
            onChanged: (v) {
              setState(() => item.remarks = v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsPanel(Map<String, double> totals, bool hasRefundable) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue.withOpacity(0.1),
            AppTheme.success.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.analytics, color: AppTheme.primaryBlue, size: 22),
              SizedBox(width: 8),
              Text(
                'Fee Totals',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          // Academic Totals
          _buildTotalRow(
            'Academic (Per Year)',
            totals['yAcad']!,
            AppTheme.primaryBlue,
          ),
          _buildTotalRow(
            'Academic (Full Course)',
            totals['fAcad']!,
            AppTheme.primaryBlue,
          ),
          const SizedBox(height: 10),

          // Optional Totals
          _buildTotalRow('Optional (Per Year)', totals['yOpt']!, Colors.orange),
          _buildTotalRow(
            'Optional (Full Course)',
            totals['fOpt']!,
            Colors.orange,
          ),
          const Divider(height: 20),

          // Grand Totals
          _buildTotalRow(
            'Grand Total (Per Year)',
            totals['yGrand']!,
            AppTheme.success,
            isBold: true,
          ),
          _buildTotalRow(
            'Grand Total (Full Course)',
            totals['fGrand']!,
            AppTheme.success,
            isBold: true,
          ),

          if (hasRefundable) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, size: 16, color: AppTheme.success),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Note: Refundable amounts included in totals',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount,
    Color color, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
