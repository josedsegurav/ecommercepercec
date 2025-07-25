class VendorsController < InheritedResources::Base

  private

    def vendor_params
      params.require(:vendor).permit(:name, :contact_person, :email, :phone, :address)
    end

end
