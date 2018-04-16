class Api::V1::CheckdepositController < ApplicationController
	def index
		checkURL = 'vpc_AdditionData='+params[:vpc_AdditionData] + '&vpc_Amount='+params[:vpc_Amount]+
				'&vpc_Command='+params[:vpc_Command]+
				'&vpc_CurrencyCode='+params[:vpc_CurrencyCode]+'&vpc_Locale=' + params[:vpc_Locale]+
				'&vpc_MerchTxnRef='+params[:vpc_MerchTxnRef]+'&vpc_Merchant='+params[:vpc_Merchant]+
				'&vpc_OrderInfo='+params[:vpc_OrderInfo]+'&vpc_TransactionNo='+params[:vpc_TransactionNo]+
				'&vpc_TxnResponseCode='+params[:vpc_TxnResponseCode]+'&vpc_Version='+params[:vpc_Version]
		hashCode = 'A3EFDFABA8653DF2342E8DAC29B51AF0'
    	hashcode = OpenSSL::HMAC.hexdigest('SHA256', [hashCode].pack('H*'), checkURL)
    	hashcode = hashcode.upcase
    	trueData = false
    	print hashcode +"\n"
    	print params[:vpc_SecureHash] + "\n"
    	if (hashcode == params[:vpc_SecureHash])
    		trueData = true
    	end
    	deposit = Deposit.find_by(refcode: params[:vpc_MerchTxnRef])
    	trueSecretKey = false
    	trueAmount = false
    	notDone = false
    	uid = ''
    	if deposit
    		trueSecretKey = true;
    		if deposit.amount.to_s == params[:vpc_Amount]
    			trueAmount = true
    		end
    		uid = deposit.user_id
    		notDone = !deposit.done
    		if notDone
    			deposit.update_attributes(done: true)
    		end
    	end
        if trueData && trueSecretKey && trueAmount && notDone
            dep = DepositHistory.new
            dep.money_account_id = User.find(uid).money_account.money_account_id
            dep.ammount = params[:vpc_Amount].to_i
            dep.save
            current_balance = current_user.money_account.ammount
            current_user.money_account.update_attributes(ammount: current_balance + params[:vpc_Amount].to_i)
        end
		render json: {
   			true: (trueData && trueSecretKey && trueAmount && notDone),
   			trueData: trueData,
   			trueSecretKey: trueSecretKey,
   			trueAmount: trueAmount,
   			notDone: notDone,
   			uid: uid
		}, status: :ok
	end
end