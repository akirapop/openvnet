Fabricator(:ip_retention, class_name: Vnet::Models::IpRetention) do
  ip_retention_container { Fabricate(:ip_retention_container) }
  ip_lease { Fabricate(:ip_lease) }
end
