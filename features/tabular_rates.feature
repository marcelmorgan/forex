Feature: Tabular Rates

  As a developer,
  In order to easily retrieve tabular rates,
  I want to be able to use the TabularRates to retrive rates formatted in a table


  Background:
    Given the tabular rates table:
      """
      <table>
        <tr><td>    </td> <td>Cash  </td> <td>Cheque</td> <td>Cash & Cheque</td></tr>
        <tr><td>    </td> <td>BUY   </td> <td>BUY   </td> <td>SELL  </td> </tr>
        <tr><td>US$ </td> <td>101.30</td> <td>103.30</td> <td>105.00</td> </tr>
        <tr><td>GBP </td> <td>166.20</td> <td>169.63</td> <td>173.30</td> </tr>
        <tr><td>CAD </td> <td> 94.51</td> <td> 96.92</td> <td> 99.72</td> </tr>
        <tr><td>EURO</td> <td>      </td> <td>137.42</td> <td>143.16</td> </tr>
      </table>
      """

  Scenario: Parsing a table with the correct options
    When the column options exist for the tabular rates parser:
      | currency_code | buy_cash | buy_draft | sell_cash | sell_draft |
      | 0             | 1        | 2         | 3         | 3          |
    And the currency translations:
      | US$  | USD |
      | EURO | EUR |
    Then parsing the table should return the following rates:
      | currency_code | buy_cash | buy_draft | sell_cash | sell_draft |
      | USD           | 101.30   | 103.30    | 105.00    | 105.00     |
      | GBP           | 166.20   | 169.63    | 173.30    | 173.30     |
      | CAD           | 94.51    | 96.92     | 99.72     | 99.72      |
      | EUR           |          | 137.42    | 143.16    | 143.16     |

  Scenario: Parsing a table with invalid options
    When the column options exist for the tabular rates parser:
      | currency_code | buy_cash | buy_draft | sell_cash | sell_draft |
      | 0             | 1        | 2         | 3         | 4          |
    Then parsing the table should raise an exception with the message:
      | sell_draft (4) does not exist in table |
