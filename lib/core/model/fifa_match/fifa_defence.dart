class FifaDefence {
  int blockTry;	//	블락 시도 수 
  int blockSuccess;	//	블락 성공 수 
  int tackleTry;	//	태클 시도 수 
  int tackleSuccess;	//	태클 성공 수   


  FifaDefence.fromJson(Map<String, dynamic> json) {
    blockTry = json['blockTry'];
    blockSuccess = json['blockSuccess'];
    tackleTry = json['tackleTry'];
    tackleSuccess     = json['tackleSuccess'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blockTry'] = blockTry;
    data['blockSuccess'] = blockSuccess;
    data['tackleTry'] = tackleTry;
    data['tackleSuccess'] = tackleSuccess;

    return data;
  }
}