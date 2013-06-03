# -*- coding: utf-8 -*-

Vnmgr::Endpoints::V10::VNetAPI.namespace '/vifs' do

  post do
    params = parse_params(@params, ["uuid","network_id","mac_addr","state","created_at","updated_at"])

    if params.has_key?("uuid")
      raise E::DuplicateUUID, params["uuid"] unless M::Vif[params["uuid"]].nil?
      params["uuid"] = M::Vif.trim_uuid(params["uuid"])
    end
    vif = data_access.vif.create(params)
    respond_with(R::Vif.generate(vif))
  end

  get do
    vifs = data_access.vif.all
    respond_with(R::VifCollection.generate(vifs))
  end

  get '/:uuid' do
    vif = data_access.vif[@params["uuid"]]
    respond_with(R::Vif.generate(vif))
  end

  delete '/:uuid' do
    vif = data_access.vif.delete({:uuid => @params["uuid"]})
    respond_with(R::Vif.generate(vif))
  end

  put '/:uuid' do
    params = parse_params(@params, ["uuid","network_id","mac_addr","state","created_at","updated_at"])
    vif = data_access.vif.update(params)
    respond_with(R::Vif.generate(vif))
  end
end