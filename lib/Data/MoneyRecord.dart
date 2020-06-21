class MoneyRecord {
     double balance;
     List<Record> record;

    MoneyRecord({this.balance, this.record});

    factory MoneyRecord.fromJson(Map<String, dynamic> json) {
        return MoneyRecord(
            balance: json['balance'],
            record: json['record'] != null ? (json['record'] as List).map((i) => Record.fromJson(i)).toList() : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['balance'] = this.balance;
        if (this.record != null) {
            data['record'] = this.record.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Record {
     double amount;
     String date;
     String remarks;

    Record({this.amount, this.date, this.remarks});

    factory Record.fromJson(Map<String, dynamic> json) {
        return Record(
            amount: json['amount'],
            date: json['date'],
            remarks: json['remarks'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['amount'] = this.amount;
        data['date'] = this.date;
        data['remarks'] = this.remarks;
        return data;
    }
}