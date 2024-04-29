BEGIN

   utl_http.set_response_error_check(true);
   utl_http.set_detailed_excp_support(true);

   xwrl_utils.ows_indivdiual_screening(
      p_debug                     => false
      , p_show_request              => false
      , p_show_response             => true
      , p_server                    => 'PROD'
      , p_listsubkey                => NULL
      , p_listrecordtype            => NULL
      , p_listrecordorigin          => NULL
      , p_custid                    => NULL
      , p_custsubid                 => NULL
      , p_passportnumber            => NULL
      , p_nationalid                => NULL
      , p_title                     => NULL
      , p_fullname                  => 'Usama bin Muhammad bin Awadnull'
      , p_givennames                => 'BIN LADIN'
      , p_familyname                => NULL
      , p_nametype                  => NULL
      , p_namequality               => NULL
      , p_primaryname               => NULL
      , p_originalscriptname        => NULL
      , p_gender                    => NULL
      , p_dateofbirth               => NULL
      , p_yearofbirth               => NULL
      , p_occupation                => NULL
      , p_address1                  => NULL
      , p_address2                  => NULL
      , p_address3                  => NULL
      , p_address4                  => NULL
      , p_city                      => NULL
      , p_state                     => NULL
      , p_postalcode                => NULL
      , p_addresscountrycode        => NULL
      , p_residencycountrycode      => NULL
      , p_countryofbirthcode        => NULL
      , p_nationalitycountrycodes   => NULL
      , p_profilehyperlink          => NULL
      , p_riskscore                 => NULL
      , p_dataconfidencescore       => NULL
      , p_dataconfidencecomment     => NULL
      , p_customstring1             => NULL
      , p_customstring2             => NULL
      , p_customstring3             => NULL
      , p_customstring4             => NULL
      , p_customstring5             => NULL
      , p_customstring6             => NULL
      , p_customstring7             => NULL
      , p_customstring8             => NULL
      , p_customstring9             => NULL
      , p_customstring10            => NULL
      , p_customstring11            => NULL
      , p_customstring12            => NULL
      , p_customstring13            => NULL
      , p_customstring14            => NULL
      , p_customstring15            => NULL
      , p_customstring16            => NULL
      , p_customstring17            => NULL
      , p_customstring18            => NULL
      , p_customstring19            => NULL
      , p_customstring20            => NULL
      , p_customstring21            => NULL
      , p_customstring22            => NULL
      , p_customstring23            => NULL
      , p_customstring24            => NULL
      , p_customstring25            => NULL
      , p_customstring26            => NULL
      , p_customstring27            => NULL
      , p_customstring28            => NULL
      , p_customstring29            => NULL
      , p_customstring30            => NULL
      , p_customstring31            => NULL
      , p_customstring32            => NULL
      , p_customstring33            => NULL
      , p_customstring34            => NULL
      , p_customstring35            => NULL
      , p_customstring36            => NULL
      , p_customstring37            => NULL
      , p_customstring38            => NULL
      , p_customstring39            => NULL
      , p_customstring40            => NULL
      , p_customdate1               => NULL
      , p_customdate2               => NULL
      , p_customdate3               => NULL
      , p_customdate4               => NULL
      , p_customdate5               => NULL
      , p_customnumber1             => NULL
      , p_customnumber2             => NULL
      , p_customnumber3             => NULL
      , p_customnumber4             => NULL
      , p_customnumber5             => NULL
   );

END;
/