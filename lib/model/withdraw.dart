class Withdraw {
  String id;
  String amount;
  String mode;
  String phone;
  String status;
  String acctnum;
   String firstName;
  String lastName;
  String member;
  String tbalance;

  
  Withdraw({this.id,this.amount,this.mode,this.phone,this.acctnum,this.status,this.firstName,this.lastName,this.member,this.tbalance});


 factory Withdraw.fromJson(Map<String, dynamic> json){
    return Withdraw(
      id : json['request_id'] as String,
      amount: json ['amount'] as String,
      mode: json ['withdraw_mode'] as String,
      phone: json ['phone'] as String,
      acctnum: json ['acct_num'] as String,
      status: json ['status'] as String,
      firstName: json ['fname'] as String,
      lastName: json ['lname'] as String,
      member: json ['member'] as String,
      tbalance: json ['t_balance'] as String,





      



    );
  

  }

  


}