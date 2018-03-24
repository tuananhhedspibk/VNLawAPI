class Api::V1::CheckpaymentController < ApplicationController
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
    	payment = Payment.find_by(refcode: params[:vpc_MerchTxnRef])
    	trueSecretKey = false
    	trueAmount = false
    	notDone = false
    	uid = ''
    	if payment
    		trueSecretKey = true;
    		if payment.amount.to_s == params[:vpc_Amount]
    			trueAmount = true
    		end
    		uid = payment.uid
    		notDone = !payment.done
    		if notDone
    			payment.update_attributes(done: true)
    		end
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