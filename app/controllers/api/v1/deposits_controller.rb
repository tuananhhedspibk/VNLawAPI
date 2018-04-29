class Api::V1::DepositsController < Api::V1::ApplicationController
  acts_as_token_authentication_handler_for User

  def create
    random = Random.new
    randomnumber = random.rand(0..1000).to_s
    time = DateTime.now.strftime('%Y%m%d%H%M%S')
    hashCode = 'A3EFDFABA8653DF2342E8DAC29B51AF0'
    urlHash = 'vpc_AccessCode=D67342C2&vpc_Amount='+
        params[:deposits][:amount] +
        '00&vpc_Command=pay&vpc_Currency=VND&vpc_Customer_Email=support@onepay.vn&vpc_Customer_Id=thanhvt&vpc_Customer_Phone=840904280949&vpc_Locale=vn&vpc_MerchTxnRef='+
        time + randomnumber +
        '&vpc_Merchant=ONEPAY&vpc_OrderInfo=JSECURETEST01&vpc_ReturnURL=https://vnlaw.datalab.vn/deposit_process&vpc_SHIP_City=Ha Noi&vpc_SHIP_Country=Viet Nam&vpc_SHIP_Provice=Hoan Kiem&vpc_SHIP_Street01=39A Ngo Quyen&vpc_TicketNo=::1&vpc_Version=2'
    url = 'vpc_AccessCode=D67342C2&vpc_Amount='+params[:deposits][:amount]+'00&vpc_Command=pay&vpc_Currency=VND&vpc_Customer_Email=support%40onepay.vn&vpc_Customer_Id=thanhvt&vpc_Customer_Phone=840904280949&vpc_Locale=vn&vpc_MerchTxnRef='+time+randomnumber+'&vpc_Merchant=ONEPAY&vpc_OrderInfo=JSECURETEST01&vpc_ReturnURL=http%3A%2F%2Fvnlaw%2Edatalab%2Evn%2Fdeposit_process&vpc_SHIP_City=Ha+Noi&vpc_SHIP_Country=Viet+Nam&vpc_SHIP_Provice=Hoan+Kiem&vpc_SHIP_Street01=39A+Ngo+Quyen&vpc_TicketNo=%3A%3A1&vpc_Version=2'
    hmac = OpenSSL::HMAC.hexdigest('SHA256', [hashCode].pack('H*'), urlHash) 
    url = 'https://mtf.onepay.vn/onecomm-pay/vpc.op?Title=VPC+3-Party&' +url +'&vpc_SecureHash=' + hmac.upcase

    deposite = Deposit.new
    unless current_user
        return render json: {
            url: nil
        }, status: :ok
    end

    deposite.user_id = current_user.id
    deposite.refcode = time + randomnumber
    deposite.done = false
    deposite.amount = (params[:deposits][:amount].to_i)
    deposite.save
    return render json: {
      url: url
    }, status: :ok
  end
end
