﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PhelebotomistMapping.aspx.cs" Inherits="Design_HomeCollection_PhelebotomistMapping" %>
                            mydata += '<td class="GridViewLabItemStyle"  id="" >' + (i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="tdLocationCity" >' + ItemData[i].City + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="tdLocationName" >' + ItemData[i].location + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="tdPincode" >' + ItemData[i].Pincode + '</td>';



                            mydata += '<td class="GridViewLabItemStyle" style="cursor:pointer;"  id="tdRoute"  title="Map Route"  onclick="OpenPopupRoute(' + ItemData[i].CityID + ',' + ItemData[i].ID + ',' + ItemData[i].Pincode + ',' + ItemData[i].Routeid.split('^')[0] + ',this)" >';

                            if (ItemData[i].Routeid != '0') {
                                for (var k = 0; k < ItemData[i].Routeid.split('^').length; k++) {
                                    if (k <= 1) {
                                        mydata += '<span style="margin-left: 5px;" id="Level1@' + ItemData[i].Routeid.split('^')[k] + '" class="level">' + ItemData[i].Route.split('^')[k] + '</span>';

                                    }
                                    if (k >= 2 && k == 2) {
                                        mydata += '<span style="margin-left: 5px;" id="Level1" class="level">More...</span>';
                                    }

                                }
                            }

                            mydata += '  </td>';


                            mydata += '<td class="GridViewLabItemStyle" id="tdPhelbo"  title="Map Phelbo"  style="cursor:pointer;"  onclick="OpenPopupPhelbo(' + ItemData[i].CityID + ',' + ItemData[i].ID + ',' + ItemData[i].Pincode + ',' + ItemData[i].Phelboid.split('^')[0] + ',\'' + ItemData[i].location + '\',this)">';

                            if (ItemData[i].Phelboid != '0') {
                                for (var k = 0; k < ItemData[i].Phelboid.split('^').length; k++) {
                                    if (k <= 1) {
                                        mydata += '<span style="margin-left: 5px;" id="Level2@' + ItemData[i].Phelboid.split('^')[k] + '" class="level">' + ItemData[i].Phelbo.split('^')[k] + '</span>';

                                    }
                                    if (k >= 2 && k == 2) {
                                        mydata += '<span style="margin-left: 5px;" id="Level2" class="level">More...</span>';
                                    }

                                }
                            }




                            mydata += '  </td>'
                            mydata += '<td class="GridViewLabItemStyle" id="tdDropLocation" title="Map DropLocation" style="cursor:pointer;" onclick="OpenPopupDropLocation(' + ItemData[i].CityID + ',' + ItemData[i].StateID + ',' + ItemData[i].ID + ',' + ItemData[i].Pincode + ',' + ItemData[i].DropLocationid.split('^')[0].split('#')[0] + ',' + ItemData[i].DropLocationid.split('^')[0].split('#')[1] + ',\'' + ItemData[i].location + '\',this)">';

                            if (ItemData[i].DropLocationid != '0') {
                                for (var k = 0; k < ItemData[i].DropLocationid.split('^').length; k++) {
                                    if (k <= 1) {
                                        mydata += '<span style="margin-left: 5px;" id="Level2@' + ItemData[i].DropLocationid.split('^')[k] + '" class="level">' + ItemData[i].DropLocation.split('^')[k] + '</span>';

                                    }
                                    if (k >= 2 && k == 2) {
                                        mydata += '<span style="margin-left: 5px;" id="Level2" class="level">More...</span>';
                                    }

                                }
                            }



                            mydata += '  </td>'




                            mydata += '<td style="display:none;" id="tdLocationid">' + ItemData[i].ID + '</td>';

                            mydata += '<td style="display:none;" id="tdStateId">' + ItemData[i].StateID + '</td>';

                            mydata += '<td style="display:none;" id="tdCityId">' + ItemData[i].CityID + '</td>';

                            mydata += '<td style="display:none;" id="tdRoutehead">' + ItemData[i].Route + '</td>';
                            mydata += '<td style="display:none;" id="tdPhelbohead">' + ItemData[i].Phelbo + '</td>';
                            mydata += '<td style="display:none;" id="tdDropLocationhead">' + ItemData[i].DropLocation + '</td>';




                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);