class ClaimsController < ApplicationController
  def notes
    @feature = Feature.claims_system(params[:claims_system]).claim_id(params[:claims_id]).first
    @notes = @feature.notes.displayable
    authorize! :read, @feature
  end

  def show
    @pg_features = Feature.claim_id(params[:claims_id])
    claims_id = params[:claims_id]
    if claims_id.count('-') == 0
      @oracle_features = OracleClaimElementaryClaim.where(claim_no: claims_id, etl_curr_rec: 'Y')
    else
      branch_cd, case_no = claims_id.split('-')
      @oracle_features = OracleClaimInc.where(etl_curr_rec: 'Y',
                                              branch_cd: branch_cd,
                                              case_no: case_no)
    end
  end
end
