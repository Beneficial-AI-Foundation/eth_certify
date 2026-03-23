(set-option :auto_config false)
(set-option :smt.mbqi false)
(set-option :smt.case_split 3)
(set-option :smt.qi.eager_threshold 100.0)
(set-option :smt.delay_units true)
(set-option :smt.arith.solver 2)
(set-option :smt.arith.nl false)
(set-option :pi.enabled false)
(set-option :rewriter.sort_disjunctions false)

;; Prelude

;; AIR prelude
(declare-sort %%Function%% 0)

(declare-sort FuelId 0)
(declare-sort Fuel 0)
(declare-const zero Fuel)
(declare-fun succ (Fuel) Fuel)
(declare-fun fuel_bool (FuelId) Bool)
(declare-fun fuel_bool_default (FuelId) Bool)
(declare-const fuel_defaults Bool)
(assert
 (=>
  fuel_defaults
  (forall ((id FuelId)) (!
    (= (fuel_bool id) (fuel_bool_default id))
    :pattern ((fuel_bool id))
    :qid prelude_fuel_defaults
    :skolemid skolem_prelude_fuel_defaults
))))
(declare-datatypes ((fndef 0)) (((fndef_singleton))))
(declare-sort Poly 0)
(declare-sort Height 0)
(declare-fun I (Int) Poly)
(declare-fun B (Bool) Poly)
(declare-fun R (Real) Poly)
(declare-fun F (fndef) Poly)
(declare-fun %I (Poly) Int)
(declare-fun %B (Poly) Bool)
(declare-fun %R (Poly) Real)
(declare-fun %F (Poly) fndef)
(declare-sort Type 0)
(declare-const BOOL Type)
(declare-const INT Type)
(declare-const NAT Type)
(declare-const REAL Type)
(declare-const CHAR Type)
(declare-const USIZE Type)
(declare-const ISIZE Type)
(declare-const TYPE%tuple%0. Type)
(declare-fun UINT (Int) Type)
(declare-fun SINT (Int) Type)
(declare-fun FLOAT (Int) Type)
(declare-fun CONST_INT (Int) Type)
(declare-fun CONST_BOOL (Bool) Type)
(declare-sort Dcr 0)
(declare-const $ Dcr)
(declare-const $slice Dcr)
(declare-const $dyn Dcr)
(declare-fun DST (Dcr) Dcr)
(declare-fun REF (Dcr) Dcr)
(declare-fun MUT_REF (Dcr) Dcr)
(declare-fun BOX (Dcr Type Dcr) Dcr)
(declare-fun RC (Dcr Type Dcr) Dcr)
(declare-fun ARC (Dcr Type Dcr) Dcr)
(declare-fun GHOST (Dcr) Dcr)
(declare-fun TRACKED (Dcr) Dcr)
(declare-fun NEVER (Dcr) Dcr)
(declare-fun CONST_PTR (Dcr) Dcr)
(declare-fun ARRAY (Dcr Type Dcr Type) Type)
(declare-fun MUTREF (Dcr Type) Type)
(declare-fun SLICE (Dcr Type) Type)
(declare-const STRSLICE Type)
(declare-const ALLOCATOR_GLOBAL Type)
(declare-fun PTR (Dcr Type) Type)
(declare-fun has_type (Poly Type) Bool)
(declare-fun sized (Dcr) Bool)
(declare-fun as_type (Poly Type) Poly)
(declare-fun mk_fun (%%Function%%) %%Function%%)
(declare-fun const_int (Type) Int)
(declare-fun const_bool (Type) Bool)
(declare-fun mut_ref_current% (Poly) Poly)
(declare-fun mut_ref_future% (Poly) Poly)
(declare-fun mut_ref_update_current% (Poly Poly) Poly)
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_current% (mut_ref_update_current% m arg)) arg)
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_current
   :skolemid skolem_prelude_mut_ref_update_current_current
)))
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_future% (mut_ref_update_current% m arg)) (mut_ref_future% m))
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_future
   :skolemid skolem_prelude_mut_ref_update_current_future
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_current% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_current% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_future% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_future% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type) (arg Poly)) (!
   (=>
    (and
     (has_type m (MUTREF d t))
     (has_type arg t)
    )
    (has_type (mut_ref_update_current% m arg) (MUTREF d t))
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_has_type
   :skolemid skolem_prelude_mut_ref_update_has_type
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (sized (DST d))
   )
   :pattern ((sized (DST d)))
   :qid prelude_sized_decorate_struct_inherit
   :skolemid skolem_prelude_sized_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (sized (REF d))
   :pattern ((sized (REF d)))
   :qid prelude_sized_decorate_ref
   :skolemid skolem_prelude_sized_decorate_ref
)))
(assert
 (forall ((d Dcr)) (!
   (sized (MUT_REF d))
   :pattern ((sized (MUT_REF d)))
   :qid prelude_sized_decorate_mut_ref
   :skolemid skolem_prelude_sized_decorate_mut_ref
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (BOX d t d2))
   :pattern ((sized (BOX d t d2)))
   :qid prelude_sized_decorate_box
   :skolemid skolem_prelude_sized_decorate_box
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (RC d t d2))
   :pattern ((sized (RC d t d2)))
   :qid prelude_sized_decorate_rc
   :skolemid skolem_prelude_sized_decorate_rc
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (ARC d t d2))
   :pattern ((sized (ARC d t d2)))
   :qid prelude_sized_decorate_arc
   :skolemid skolem_prelude_sized_decorate_arc
)))
(assert
 (forall ((d Dcr)) (!
   (sized (GHOST d))
   :pattern ((sized (GHOST d)))
   :qid prelude_sized_decorate_ghost
   :skolemid skolem_prelude_sized_decorate_ghost
)))
(assert
 (forall ((d Dcr)) (!
   (sized (TRACKED d))
   :pattern ((sized (TRACKED d)))
   :qid prelude_sized_decorate_tracked
   :skolemid skolem_prelude_sized_decorate_tracked
)))
(assert
 (forall ((d Dcr)) (!
   (sized (NEVER d))
   :pattern ((sized (NEVER d)))
   :qid prelude_sized_decorate_never
   :skolemid skolem_prelude_sized_decorate_never
)))
(assert
 (forall ((d Dcr)) (!
   (sized (CONST_PTR d))
   :pattern ((sized (CONST_PTR d)))
   :qid prelude_sized_decorate_const_ptr
   :skolemid skolem_prelude_sized_decorate_const_ptr
)))
(assert
 (sized $)
)
(assert
 (forall ((i Int)) (!
   (= i (const_int (CONST_INT i)))
   :pattern ((CONST_INT i))
   :qid prelude_type_id_const_int
   :skolemid skolem_prelude_type_id_const_int
)))
(assert
 (forall ((b Bool)) (!
   (= b (const_bool (CONST_BOOL b)))
   :pattern ((CONST_BOOL b))
   :qid prelude_type_id_const_bool
   :skolemid skolem_prelude_type_id_const_bool
)))
(assert
 (forall ((b Bool)) (!
   (has_type (B b) BOOL)
   :pattern ((has_type (B b) BOOL))
   :qid prelude_has_type_bool
   :skolemid skolem_prelude_has_type_bool
)))
(assert
 (forall ((r Real)) (!
   (has_type (R r) REAL)
   :pattern ((has_type (R r) REAL))
   :qid prelude_has_type_real
   :skolemid skolem_prelude_has_type_real
)))
(assert
 (forall ((x Poly) (t Type)) (!
   (and
    (has_type (as_type x t) t)
    (=>
     (has_type x t)
     (= x (as_type x t))
   ))
   :pattern ((as_type x t))
   :qid prelude_as_type
   :skolemid skolem_prelude_as_type
)))
(assert
 (forall ((x %%Function%%)) (!
   (= (mk_fun x) x)
   :pattern ((mk_fun x))
   :qid prelude_mk_fun
   :skolemid skolem_prelude_mk_fun
)))
(assert
 (forall ((x Bool)) (!
   (= x (%B (B x)))
   :pattern ((B x))
   :qid prelude_unbox_box_bool
   :skolemid skolem_prelude_unbox_box_bool
)))
(assert
 (forall ((x Int)) (!
   (= x (%I (I x)))
   :pattern ((I x))
   :qid prelude_unbox_box_int
   :skolemid skolem_prelude_unbox_box_int
)))
(assert
 (forall ((x Real)) (!
   (= x (%R (R x)))
   :pattern ((R x))
   :qid prelude_unbox_box_real
   :skolemid skolem_prelude_unbox_box_real
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x BOOL)
    (= x (B (%B x)))
   )
   :pattern ((has_type x BOOL))
   :qid prelude_box_unbox_bool
   :skolemid skolem_prelude_box_unbox_bool
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x INT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x INT))
   :qid prelude_box_unbox_int
   :skolemid skolem_prelude_box_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x NAT))
   :qid prelude_box_unbox_nat
   :skolemid skolem_prelude_box_unbox_nat
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_box_unbox_usize
   :skolemid skolem_prelude_box_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_box_unbox_isize
   :skolemid skolem_prelude_box_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_box_unbox_uint
   :skolemid skolem_prelude_box_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x CHAR)
    (= x (I (%I x)))
   )
   :pattern ((has_type x CHAR))
   :qid prelude_box_unbox_char
   :skolemid skolem_prelude_box_unbox_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x REAL)
    (= x (R (%R x)))
   )
   :pattern ((has_type x REAL))
   :qid prelude_box_unbox_real
   :skolemid skolem_prelude_box_unbox_real
)))
(declare-fun ext_eq (Bool Type Poly Poly) Bool)
(assert
 (forall ((deep Bool) (t Type) (x Poly) (y Poly)) (!
   (= (= x y) (ext_eq deep t x y))
   :pattern ((ext_eq deep t x y))
   :qid prelude_ext_eq
   :skolemid skolem_prelude_ext_eq
)))
(declare-const SZ Int)
(assert
 (or
  (= SZ 32)
  (= SZ 64)
))
(declare-fun uHi (Int) Int)
(declare-fun iLo (Int) Int)
(declare-fun iHi (Int) Int)
(assert
 (= (uHi 8) 256)
)
(assert
 (= (uHi 16) 65536)
)
(assert
 (= (uHi 32) 4294967296)
)
(assert
 (= (uHi 64) 18446744073709551616)
)
(assert
 (= (uHi 128) (+ 1 340282366920938463463374607431768211455))
)
(assert
 (= (iLo 8) (- 128))
)
(assert
 (= (iLo 16) (- 32768))
)
(assert
 (= (iLo 32) (- 2147483648))
)
(assert
 (= (iLo 64) (- 9223372036854775808))
)
(assert
 (= (iLo 128) (- 170141183460469231731687303715884105728))
)
(assert
 (= (iHi 8) 128)
)
(assert
 (= (iHi 16) 32768)
)
(assert
 (= (iHi 32) 2147483648)
)
(assert
 (= (iHi 64) 9223372036854775808)
)
(assert
 (= (iHi 128) 170141183460469231731687303715884105728)
)
(declare-fun nClip (Int) Int)
(declare-fun uClip (Int Int) Int)
(declare-fun iClip (Int Int) Int)
(declare-fun charClip (Int) Int)
(assert
 (forall ((i Int)) (!
   (and
    (<= 0 (nClip i))
    (=>
     (<= 0 i)
     (= i (nClip i))
   ))
   :pattern ((nClip i))
   :qid prelude_nat_clip
   :skolemid skolem_prelude_nat_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= 0 (uClip bits i))
    (< (uClip bits i) (uHi bits))
    (=>
     (and
      (<= 0 i)
      (< i (uHi bits))
     )
     (= i (uClip bits i))
   ))
   :pattern ((uClip bits i))
   :qid prelude_u_clip
   :skolemid skolem_prelude_u_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= (iLo bits) (iClip bits i))
    (< (iClip bits i) (iHi bits))
    (=>
     (and
      (<= (iLo bits) i)
      (< i (iHi bits))
     )
     (= i (iClip bits i))
   ))
   :pattern ((iClip bits i))
   :qid prelude_i_clip
   :skolemid skolem_prelude_i_clip
)))
(assert
 (forall ((i Int)) (!
   (and
    (or
     (and
      (<= 0 (charClip i))
      (<= (charClip i) 55295)
     )
     (and
      (<= 57344 (charClip i))
      (<= (charClip i) 1114111)
    ))
    (=>
     (or
      (and
       (<= 0 i)
       (<= i 55295)
      )
      (and
       (<= 57344 i)
       (<= i 1114111)
     ))
     (= i (charClip i))
   ))
   :pattern ((charClip i))
   :qid prelude_char_clip
   :skolemid skolem_prelude_char_clip
)))
(declare-fun uInv (Int Int) Bool)
(declare-fun iInv (Int Int) Bool)
(declare-fun charInv (Int) Bool)
(assert
 (forall ((bits Int) (i Int)) (!
   (= (uInv bits i) (and
     (<= 0 i)
     (< i (uHi bits))
   ))
   :pattern ((uInv bits i))
   :qid prelude_u_inv
   :skolemid skolem_prelude_u_inv
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (= (iInv bits i) (and
     (<= (iLo bits) i)
     (< i (iHi bits))
   ))
   :pattern ((iInv bits i))
   :qid prelude_i_inv
   :skolemid skolem_prelude_i_inv
)))
(assert
 (forall ((i Int)) (!
   (= (charInv i) (or
     (and
      (<= 0 i)
      (<= i 55295)
     )
     (and
      (<= 57344 i)
      (<= i 1114111)
   )))
   :pattern ((charInv i))
   :qid prelude_char_inv
   :skolemid skolem_prelude_char_inv
)))
(assert
 (forall ((x Int)) (!
   (has_type (I x) INT)
   :pattern ((has_type (I x) INT))
   :qid prelude_has_type_int
   :skolemid skolem_prelude_has_type_int
)))
(assert
 (forall ((x Int)) (!
   (=>
    (<= 0 x)
    (has_type (I x) NAT)
   )
   :pattern ((has_type (I x) NAT))
   :qid prelude_has_type_nat
   :skolemid skolem_prelude_has_type_nat
)))
(assert
 (forall ((x Int)) (!
   (=>
    (uInv SZ x)
    (has_type (I x) USIZE)
   )
   :pattern ((has_type (I x) USIZE))
   :qid prelude_has_type_usize
   :skolemid skolem_prelude_has_type_usize
)))
(assert
 (forall ((x Int)) (!
   (=>
    (iInv SZ x)
    (has_type (I x) ISIZE)
   )
   :pattern ((has_type (I x) ISIZE))
   :qid prelude_has_type_isize
   :skolemid skolem_prelude_has_type_isize
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (UINT bits))
   )
   :pattern ((has_type (I x) (UINT bits)))
   :qid prelude_has_type_uint
   :skolemid skolem_prelude_has_type_uint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (iInv bits x)
    (has_type (I x) (SINT bits))
   )
   :pattern ((has_type (I x) (SINT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (FLOAT bits))
   )
   :pattern ((has_type (I x) (FLOAT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((x Int)) (!
   (=>
    (charInv x)
    (has_type (I x) CHAR)
   )
   :pattern ((has_type (I x) CHAR))
   :qid prelude_has_type_char
   :skolemid skolem_prelude_has_type_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (<= 0 (%I x))
   )
   :pattern ((has_type x NAT))
   :qid prelude_unbox_int
   :skolemid skolem_prelude_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (uInv SZ (%I x))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_unbox_usize
   :skolemid skolem_prelude_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (iInv SZ (%I x))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_unbox_isize
   :skolemid skolem_prelude_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_unbox_uint
   :skolemid skolem_prelude_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (iInv bits (%I x))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(declare-fun Add (Int Int) Int)
(declare-fun Sub (Int Int) Int)
(declare-fun Mul (Int Int) Int)
(declare-fun EucDiv (Int Int) Int)
(declare-fun EucMod (Int Int) Int)
(declare-fun RAdd (Real Real) Real)
(declare-fun RSub (Real Real) Real)
(declare-fun RMul (Real Real) Real)
(declare-fun RDiv (Real Real) Real)
(assert
 (forall ((x Int) (y Int)) (!
   (= (Add x y) (+ x y))
   :pattern ((Add x y))
   :qid prelude_add
   :skolemid skolem_prelude_add
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Sub x y) (- x y))
   :pattern ((Sub x y))
   :qid prelude_sub
   :skolemid skolem_prelude_sub
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Mul x y) (* x y))
   :pattern ((Mul x y))
   :qid prelude_mul
   :skolemid skolem_prelude_mul
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucDiv x y) (div x y))
   :pattern ((EucDiv x y))
   :qid prelude_eucdiv
   :skolemid skolem_prelude_eucdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucMod x y) (mod x y))
   :pattern ((EucMod x y))
   :qid prelude_eucmod
   :skolemid skolem_prelude_eucmod
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RAdd x y) (+ x y))
   :pattern ((RAdd x y))
   :qid prelude_radd
   :skolemid skolem_prelude_radd
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RSub x y) (- x y))
   :pattern ((RSub x y))
   :qid prelude_rsub
   :skolemid skolem_prelude_rsub
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RMul x y) (* x y))
   :pattern ((RMul x y))
   :qid prelude_rmul
   :skolemid skolem_prelude_rmul
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RDiv x y) (/ x y))
   :pattern ((RDiv x y))
   :qid prelude_rdiv
   :skolemid skolem_prelude_rdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (<= 0 y)
    )
    (<= 0 (Mul x y))
   )
   :pattern ((Mul x y))
   :qid prelude_mul_nats
   :skolemid skolem_prelude_mul_nats
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucDiv x y))
     (<= (EucDiv x y) x)
   ))
   :pattern ((EucDiv x y))
   :qid prelude_div_unsigned_in_bounds
   :skolemid skolem_prelude_div_unsigned_in_bounds
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucMod x y))
     (< (EucMod x y) y)
   ))
   :pattern ((EucMod x y))
   :qid prelude_mod_unsigned_in_bounds
   :skolemid skolem_prelude_mod_unsigned_in_bounds
)))
(declare-fun bitxor (Poly Poly) Int)
(declare-fun bitand (Poly Poly) Int)
(declare-fun bitor (Poly Poly) Int)
(declare-fun bitshr (Poly Poly) Int)
(declare-fun bitshl (Poly Poly) Int)
(declare-fun bitnot (Poly) Int)
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitxor x y))
   )
   :pattern ((uClip bits (bitxor x y)))
   :qid prelude_bit_xor_u_inv
   :skolemid skolem_prelude_bit_xor_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitxor x y))
   )
   :pattern ((iClip bits (bitxor x y)))
   :qid prelude_bit_xor_i_inv
   :skolemid skolem_prelude_bit_xor_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitor x y))
   )
   :pattern ((uClip bits (bitor x y)))
   :qid prelude_bit_or_u_inv
   :skolemid skolem_prelude_bit_or_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitor x y))
   )
   :pattern ((iClip bits (bitor x y)))
   :qid prelude_bit_or_i_inv
   :skolemid skolem_prelude_bit_or_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitand x y))
   )
   :pattern ((uClip bits (bitand x y)))
   :qid prelude_bit_and_u_inv
   :skolemid skolem_prelude_bit_and_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitand x y))
   )
   :pattern ((iClip bits (bitand x y)))
   :qid prelude_bit_and_i_inv
   :skolemid skolem_prelude_bit_and_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (<= 0 (%I y))
    )
    (uInv bits (bitshr x y))
   )
   :pattern ((uClip bits (bitshr x y)))
   :qid prelude_bit_shr_u_inv
   :skolemid skolem_prelude_bit_shr_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (<= 0 (%I y))
    )
    (iInv bits (bitshr x y))
   )
   :pattern ((iClip bits (bitshr x y)))
   :qid prelude_bit_shr_i_inv
   :skolemid skolem_prelude_bit_shr_i_inv
)))
(declare-fun singular_mod (Int Int) Int)
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (not (= y 0))
    (= (EucMod x y) (singular_mod x y))
   )
   :pattern ((singular_mod x y))
   :qid prelude_singularmod
   :skolemid skolem_prelude_singularmod
)))
(declare-fun has_resolved (Dcr Type Poly) Bool)
(declare-fun closure_req (Type Dcr Type Poly Poly) Bool)
(declare-fun closure_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun default_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun height (Poly) Height)
(declare-fun height_lt (Height Height) Bool)
(declare-fun fun_from_recursive_field (Poly) Poly)
(declare-fun check_decrease_int (Int Int Bool) Bool)
(assert
 (forall ((cur Int) (prev Int) (otherwise Bool)) (!
   (= (check_decrease_int cur prev otherwise) (or
     (and
      (<= 0 cur)
      (< cur prev)
     )
     (and
      (= cur prev)
      otherwise
   )))
   :pattern ((check_decrease_int cur prev otherwise))
   :qid prelude_check_decrease_int
   :skolemid skolem_prelude_check_decrease_int
)))
(declare-fun check_decrease_height (Poly Poly Bool) Bool)
(assert
 (forall ((cur Poly) (prev Poly) (otherwise Bool)) (!
   (= (check_decrease_height cur prev otherwise) (or
     (height_lt (height cur) (height prev))
     (and
      (= (height cur) (height prev))
      otherwise
   )))
   :pattern ((check_decrease_height cur prev otherwise))
   :qid prelude_check_decrease_height
   :skolemid skolem_prelude_check_decrease_height
)))
(assert
 (forall ((x Height) (y Height)) (!
   (= (height_lt x y) (and
     ((_ partial-order 0) x y)
     (not (= x y))
   ))
   :pattern ((height_lt x y))
   :qid prelude_height_lt
   :skolemid skolem_prelude_height_lt
)))

;; MODULE 'module logimpl_v'
;; src/logimpl_v.rs:538:5: 538:108 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor.
 FuelId
)
(declare-const fuel%vstd!std_specs.option.impl&%0.arrow_0. FuelId)
(declare-const fuel%vstd!std_specs.option.spec_unwrap. FuelId)
(declare-const fuel%vstd!std_specs.vec.axiom_spec_len. FuelId)
(declare-const fuel%vstd!std_specs.vec.axiom_vec_has_resolved. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_add. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_empty. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_index. FuelId)
(declare-const fuel%vstd!seq.lemma_seq_two_subranges_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_add_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_add_index1. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_add_index2. FuelId)
(declare-const fuel%vstd!seq_lib.impl&%0.add_empty_left. FuelId)
(declare-const fuel%vstd!seq_lib.impl&%0.add_empty_right. FuelId)
(declare-const fuel%vstd!set.axiom_set_ext_equal. FuelId)
(declare-const fuel%vstd!set.axiom_set_ext_equal_deep. FuelId)
(declare-const fuel%vstd!slice.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!slice.axiom_spec_len. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_ext_equal. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_has_resolved. FuelId)
(declare-const fuel%vstd!view.impl&%0.view. FuelId)
(declare-const fuel%vstd!view.impl&%2.view. FuelId)
(declare-const fuel%vstd!view.impl&%4.view. FuelId)
(declare-const fuel%vstd!view.impl&%6.view. FuelId)
(declare-const fuel%vstd!view.impl&%10.view. FuelId)
(declare-const fuel%vstd!view.impl&%12.view. FuelId)
(declare-const fuel%vstd!view.impl&%14.view. FuelId)
(declare-const fuel%vstd!view.impl&%16.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%44.view. FuelId)
(declare-const fuel%vstd!view.impl&%46.view. FuelId)
(declare-const fuel%pmemlog!infinitelog_t.impl&%0.initialize. FuelId)
(declare-const fuel%pmemlog!infinitelog_t.impl&%0.append. FuelId)
(declare-const fuel%pmemlog!infinitelog_t.impl&%0.advance_head. FuelId)
(declare-const fuel%pmemlog!logimpl_v.incorruptible_bool_pos. FuelId)
(declare-const fuel%pmemlog!logimpl_v.header1_pos. FuelId)
(declare-const fuel%pmemlog!logimpl_v.header2_pos. FuelId)
(declare-const fuel%pmemlog!logimpl_v.header_crc_offset. FuelId)
(declare-const fuel%pmemlog!logimpl_v.header_head_offset. FuelId)
(declare-const fuel%pmemlog!logimpl_v.header_tail_offset. FuelId)
(declare-const fuel%pmemlog!logimpl_v.header_log_size_offset. FuelId)
(declare-const fuel%pmemlog!logimpl_v.header_size. FuelId)
(declare-const fuel%pmemlog!logimpl_v.pm_to_views. FuelId)
(declare-const fuel%pmemlog!logimpl_v.spec_get_live_header. FuelId)
(declare-const fuel%pmemlog!logimpl_v.permissions_depend_only_on_recovery_view. FuelId)
(declare-const fuel%pmemlog!logimpl_v.spec_bytes_to_metadata. FuelId)
(declare-const fuel%pmemlog!logimpl_v.spec_bytes_to_header. FuelId)
(declare-const fuel%pmemlog!logimpl_v.update_data_view_postcond. FuelId)
(declare-const fuel%pmemlog!logimpl_v.live_data_view_eq. FuelId)
(declare-const fuel%pmemlog!logimpl_v.spec_addr_logical_to_physical. FuelId)
(declare-const fuel%pmemlog!logimpl_v.contents_offset. FuelId)
(declare-const fuel%pmemlog!logimpl_v.impl&%0.log_state_is_valid. FuelId)
(declare-const fuel%pmemlog!logimpl_v.impl&%0.recover. FuelId)
(declare-const fuel%pmemlog!logimpl_v.impl&%0.inv_pm_contents. FuelId)
(declare-const fuel%pmemlog!logimpl_v.impl&%0.inv. FuelId)
(declare-const fuel%pmemlog!main_t.recovery_view. FuelId)
(declare-const fuel%pmemlog!main_t.read_correct_modulo_corruption. FuelId)
(declare-const fuel%pmemlog!pmemspec_t.all_elements_unique. FuelId)
(declare-const fuel%pmemlog!pmemspec_t.maybe_corrupted. FuelId)
(declare-const fuel%pmemlog!pmemspec_t.crc_size. FuelId)
(declare-const fuel%pmemlog!pmemspec_t.cdb0_val. FuelId)
(declare-const fuel%pmemlog!pmemspec_t.cdb1_val. FuelId)
(declare-const fuel%pmemlog!pmemspec_t.persistence_chunk_size. FuelId)
(declare-const fuel%pmemlog!pmemspec_t.update_byte_to_reflect_write. FuelId)
(declare-const fuel%pmemlog!pmemspec_t.update_contents_to_reflect_write. FuelId)
(declare-const fuel%pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.
 FuelId
)
(declare-const fuel%pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.
 FuelId
)
(declare-const fuel%vstd!array.group_array_axioms. FuelId)
(declare-const fuel%vstd!function.group_function_axioms. FuelId)
(declare-const fuel%vstd!laws_cmp.group_laws_cmp. FuelId)
(declare-const fuel%vstd!laws_eq.bool_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.usize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.isize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.group_laws_eq. FuelId)
(declare-const fuel%vstd!layout.group_layout_axioms. FuelId)
(declare-const fuel%vstd!map.group_map_axioms. FuelId)
(declare-const fuel%vstd!multiset.group_multiset_axioms. FuelId)
(declare-const fuel%vstd!raw_ptr.group_raw_ptr_axioms. FuelId)
(declare-const fuel%vstd!seq.group_seq_axioms. FuelId)
(declare-const fuel%vstd!seq_lib.group_filter_ensures. FuelId)
(declare-const fuel%vstd!seq_lib.group_seq_lib_default. FuelId)
(declare-const fuel%vstd!set.group_set_axioms. FuelId)
(declare-const fuel%vstd!set_lib.group_set_lib_default. FuelId)
(declare-const fuel%vstd!slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!string.group_string_axioms. FuelId)
(declare-const fuel%vstd!std_specs.bits.group_bits_axioms. FuelId)
(declare-const fuel%vstd!std_specs.control_flow.group_control_flow_axioms. FuelId)
(declare-const fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms. FuelId)
(declare-const fuel%vstd!std_specs.hash.group_hash_axioms. FuelId)
(declare-const fuel%vstd!std_specs.range.group_range_axioms. FuelId)
(declare-const fuel%vstd!std_specs.slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vec.group_vec_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. FuelId)
(declare-const fuel%vstd!group_vstd_default. FuelId)
(assert
 (distinct fuel%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. fuel%vstd!std_specs.option.impl&%0.arrow_0.
  fuel%vstd!std_specs.option.spec_unwrap. fuel%vstd!std_specs.vec.axiom_spec_len. fuel%vstd!std_specs.vec.axiom_vec_has_resolved.
  fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized.
  fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.impl&%0.spec_add. fuel%vstd!seq.axiom_seq_index_decreases.
  fuel%vstd!seq.axiom_seq_subrange_decreases. fuel%vstd!seq.axiom_seq_empty. fuel%vstd!seq.axiom_seq_new_len.
  fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep.
  fuel%vstd!seq.axiom_seq_subrange_len. fuel%vstd!seq.axiom_seq_subrange_index. fuel%vstd!seq.lemma_seq_two_subranges_index.
  fuel%vstd!seq.axiom_seq_add_len. fuel%vstd!seq.axiom_seq_add_index1. fuel%vstd!seq.axiom_seq_add_index2.
  fuel%vstd!seq_lib.impl&%0.add_empty_left. fuel%vstd!seq_lib.impl&%0.add_empty_right.
  fuel%vstd!set.axiom_set_ext_equal. fuel%vstd!set.axiom_set_ext_equal_deep. fuel%vstd!slice.impl&%2.spec_index.
  fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal. fuel%vstd!slice.axiom_slice_has_resolved.
  fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view. fuel%vstd!view.impl&%4.view.
  fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%10.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%22.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%44.view. fuel%vstd!view.impl&%46.view.
  fuel%pmemlog!infinitelog_t.impl&%0.initialize. fuel%pmemlog!infinitelog_t.impl&%0.append.
  fuel%pmemlog!infinitelog_t.impl&%0.advance_head. fuel%pmemlog!logimpl_v.incorruptible_bool_pos.
  fuel%pmemlog!logimpl_v.header1_pos. fuel%pmemlog!logimpl_v.header2_pos. fuel%pmemlog!logimpl_v.header_crc_offset.
  fuel%pmemlog!logimpl_v.header_head_offset. fuel%pmemlog!logimpl_v.header_tail_offset.
  fuel%pmemlog!logimpl_v.header_log_size_offset. fuel%pmemlog!logimpl_v.header_size.
  fuel%pmemlog!logimpl_v.pm_to_views. fuel%pmemlog!logimpl_v.spec_get_live_header.
  fuel%pmemlog!logimpl_v.permissions_depend_only_on_recovery_view. fuel%pmemlog!logimpl_v.spec_bytes_to_metadata.
  fuel%pmemlog!logimpl_v.spec_bytes_to_header. fuel%pmemlog!logimpl_v.update_data_view_postcond.
  fuel%pmemlog!logimpl_v.live_data_view_eq. fuel%pmemlog!logimpl_v.spec_addr_logical_to_physical.
  fuel%pmemlog!logimpl_v.contents_offset. fuel%pmemlog!logimpl_v.impl&%0.log_state_is_valid.
  fuel%pmemlog!logimpl_v.impl&%0.recover. fuel%pmemlog!logimpl_v.impl&%0.inv_pm_contents.
  fuel%pmemlog!logimpl_v.impl&%0.inv. fuel%pmemlog!main_t.recovery_view. fuel%pmemlog!main_t.read_correct_modulo_corruption.
  fuel%pmemlog!pmemspec_t.all_elements_unique. fuel%pmemlog!pmemspec_t.maybe_corrupted.
  fuel%pmemlog!pmemspec_t.crc_size. fuel%pmemlog!pmemspec_t.cdb0_val. fuel%pmemlog!pmemspec_t.cdb1_val.
  fuel%pmemlog!pmemspec_t.persistence_chunk_size. fuel%pmemlog!pmemspec_t.update_byte_to_reflect_write.
  fuel%pmemlog!pmemspec_t.update_contents_to_reflect_write. fuel%pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.
  fuel%pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write. fuel%vstd!array.group_array_axioms.
  fuel%vstd!function.group_function_axioms. fuel%vstd!laws_cmp.group_laws_cmp. fuel%vstd!laws_eq.bool_laws.group_laws_eq.
  fuel%vstd!laws_eq.u8_laws.group_laws_eq. fuel%vstd!laws_eq.i8_laws.group_laws_eq.
  fuel%vstd!laws_eq.u16_laws.group_laws_eq. fuel%vstd!laws_eq.i16_laws.group_laws_eq.
  fuel%vstd!laws_eq.u32_laws.group_laws_eq. fuel%vstd!laws_eq.i32_laws.group_laws_eq.
  fuel%vstd!laws_eq.u64_laws.group_laws_eq. fuel%vstd!laws_eq.i64_laws.group_laws_eq.
  fuel%vstd!laws_eq.u128_laws.group_laws_eq. fuel%vstd!laws_eq.i128_laws.group_laws_eq.
  fuel%vstd!laws_eq.usize_laws.group_laws_eq. fuel%vstd!laws_eq.isize_laws.group_laws_eq.
  fuel%vstd!laws_eq.group_laws_eq. fuel%vstd!layout.group_layout_axioms. fuel%vstd!map.group_map_axioms.
  fuel%vstd!multiset.group_multiset_axioms. fuel%vstd!raw_ptr.group_raw_ptr_axioms.
  fuel%vstd!seq.group_seq_axioms. fuel%vstd!seq_lib.group_filter_ensures. fuel%vstd!seq_lib.group_seq_lib_default.
  fuel%vstd!set.group_set_axioms. fuel%vstd!set_lib.group_set_lib_default. fuel%vstd!slice.group_slice_axioms.
  fuel%vstd!string.group_string_axioms. fuel%vstd!std_specs.bits.group_bits_axioms.
  fuel%vstd!std_specs.control_flow.group_control_flow_axioms. fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.
  fuel%vstd!std_specs.hash.group_hash_axioms. fuel%vstd!std_specs.range.group_range_axioms.
  fuel%vstd!std_specs.slice.group_slice_axioms. fuel%vstd!std_specs.vec.group_vec_axioms.
  fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. fuel%vstd!group_vstd_default.
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
  (and
   (fuel_bool_default fuel%vstd!laws_eq.bool_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.usize_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.isize_laws.group_laws_eq.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
  (and
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq.)
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
  (and
   (fuel_bool_default fuel%vstd!seq.axiom_seq_index_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_empty.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal_deep.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_index.)
   (fuel_bool_default fuel%vstd!seq.lemma_seq_two_subranges_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_add_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_add_index1.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_add_index2.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
  (and
   (fuel_bool_default fuel%vstd!seq_lib.group_filter_ensures.)
   (fuel_bool_default fuel%vstd!seq_lib.impl&%0.add_empty_left.)
   (fuel_bool_default fuel%vstd!seq_lib.impl&%0.add_empty_right.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!set.group_set_axioms.)
  (and
   (fuel_bool_default fuel%vstd!set.axiom_set_ext_equal.)
   (fuel_bool_default fuel%vstd!set.axiom_set_ext_equal_deep.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
  (and
   (fuel_bool_default fuel%vstd!slice.axiom_spec_len.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_ext_equal.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_has_resolved.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!std_specs.vec.group_vec_axioms.)
  (and
   (fuel_bool_default fuel%vstd!std_specs.vec.axiom_spec_len.)
   (fuel_bool_default fuel%vstd!std_specs.vec.axiom_vec_has_resolved.)
)))
(assert
 (fuel_bool_default fuel%vstd!group_vstd_default.)
)
(assert
 (=>
  (fuel_bool_default fuel%vstd!group_vstd_default.)
  (and
   (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
   (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
   (fuel_bool_default fuel%vstd!map.group_map_axioms.)
   (fuel_bool_default fuel%vstd!set.group_set_axioms.)
   (fuel_bool_default fuel%vstd!set_lib.group_set_lib_default.)
   (fuel_bool_default fuel%vstd!multiset.group_multiset_axioms.)
   (fuel_bool_default fuel%vstd!function.group_function_axioms.)
   (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_cmp.group_laws_cmp.)
   (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!array.group_array_axioms.)
   (fuel_bool_default fuel%vstd!string.group_string_axioms.)
   (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
   (fuel_bool_default fuel%vstd!layout.group_layout_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.range.group_range_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.bits.group_bits_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.control_flow.group_control_flow_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vec.group_vec_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.hash.group_hash_axioms.)
)))

;; Trait-Decls
(declare-fun tr_bound%vstd!slice.SliceAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!view.View. (Dcr Type) Bool)
(declare-fun tr_bound%core!alloc.Allocator. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.option.OptionAdditionalFns. (Dcr Type Dcr Type)
 Bool
)
(declare-fun tr_bound%pmemlog!pmemspec_t.PersistentMemory. (Dcr Type) Bool)
(declare-fun tr_bound%pmemlog!sccf.CheckPermission. (Dcr Type Dcr Type) Bool)

;; Associated-Type-Decls
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)

;; Datatypes
(declare-fun pointee_metadata% (Dcr) Type)
(declare-fun pointee_metadata%% (Dcr) Dcr)
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata% d) TYPE%tuple%0.)
   )
   :pattern ((pointee_metadata% d))
   :qid prelude_project_pointee_metadata_sized
   :skolemid skolem_prelude_project_pointee_metadata_sized
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata%% d) $)
   )
   :pattern ((pointee_metadata%% d))
   :qid prelude_project_pointee_metadata_decoration_sized
   :skolemid skolem_prelude_project_pointee_metadata_decoration_sized
)))
(assert
 (= (pointee_metadata% $slice) USIZE)
)
(assert
 (= (pointee_metadata%% $slice) $)
)
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata% (DST d)) (pointee_metadata% d))
   :pattern ((pointee_metadata% (DST d)))
   :qid prelude_project_pointee_metadata_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata%% (DST d)) (pointee_metadata%% d))
   :pattern ((pointee_metadata%% (DST d)))
   :qid prelude_project_pointee_metadata_decoration_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decoration_decorate_struct_inherit
)))
(declare-sort alloc!vec.Vec<u8./allocator_global%.>. 0)
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<int.>. 0)
(declare-sort vstd!seq.Seq<u8.>. 0)
(declare-sort vstd!set.Set<int.>. 0)
(declare-sort slice%<u8.>. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((core!option.Option. 0) (core!result.Result. 0) (vstd!raw_ptr.PtrData.
   0
  ) (pmemlog!infinitelog_t.AbstractInfiniteLogState. 0) (pmemlog!logimpl_v.PersistentHeader.
   0
  ) (pmemlog!logimpl_v.PersistentHeaderMetadata. 0) (pmemlog!logimpl_v.HeaderView. 0)
  (pmemlog!logimpl_v.UntrustedLogImpl. 0) (pmemlog!main_t.InfiniteLogErr. 0) (pmemlog!pmemspec_t.PersistentMemoryConstants.
   0
  ) (tuple%0. 0) (tuple%2. 0) (tuple%3. 0)
 ) (((core!option.Option./None) (core!option.Option./Some (core!option.Option./Some/?0
     Poly
   ))
  ) ((core!result.Result./Ok (core!result.Result./Ok/?0 Poly)) (core!result.Result./Err
    (core!result.Result./Err/?0 Poly)
   )
  ) ((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/?head
     Int
    ) (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/?log vstd!seq.Seq<u8.>.)
    (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/?capacity
     Int
   ))
  ) ((pmemlog!logimpl_v.PersistentHeader./PersistentHeader (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/?crc
     Int
    ) (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/?metadata pmemlog!logimpl_v.PersistentHeaderMetadata.)
   )
  ) ((pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/?head
     Int
    ) (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/?tail Int)
    (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/?log_size Int)
   )
  ) ((pmemlog!logimpl_v.HeaderView./HeaderView (pmemlog!logimpl_v.HeaderView./HeaderView/?header1
     pmemlog!logimpl_v.PersistentHeader.
    ) (pmemlog!logimpl_v.HeaderView./HeaderView/?header2 pmemlog!logimpl_v.PersistentHeader.)
   )
  ) ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/?incorruptible_bool
     Int
    ) (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/?header_crc Int) (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/?head
     Int
    ) (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/?tail Int) (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/?log_size
     Int
   ))
  ) ((pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/?required_space
     Int
    )
   ) (pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead (pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/?head
     Int
    )
   ) (pmemlog!main_t.InfiniteLogErr./CantReadPastTail (pmemlog!main_t.InfiniteLogErr./CantReadPastTail/?tail
     Int
    )
   ) (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/?available_space
     Int
    )
   ) (pmemlog!main_t.InfiniteLogErr./CRCMismatch) (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead
    (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/?head Int)
   ) (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/?tail
     Int
   ))
  ) ((pmemlog!pmemspec_t.PersistentMemoryConstants./PersistentMemoryConstants (pmemlog!pmemspec_t.PersistentMemoryConstants./PersistentMemoryConstants/?impervious_to_corruption
     Bool
   ))
  ) ((tuple%0./tuple%0)) ((tuple%2./tuple%2 (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1
     Poly
   ))
  ) ((tuple%3./tuple%3 (tuple%3./tuple%3/?0 Poly) (tuple%3./tuple%3/?1 Poly) (tuple%3./tuple%3/?2
     Poly
)))))
(declare-fun core!option.Option./Some/0 (Dcr Type core!option.Option.) Poly)
(declare-fun core!result.Result./Ok/0 (Dcr Type Dcr Type core!result.Result.) Poly)
(declare-fun core!result.Result./Err/0 (Dcr Type Dcr Type core!result.Result.) Poly)
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head
 (pmemlog!infinitelog_t.AbstractInfiniteLogState.) Int
)
(declare-fun pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log
 (pmemlog!infinitelog_t.AbstractInfiniteLogState.) vstd!seq.Seq<u8.>.
)
(declare-fun pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/capacity
 (pmemlog!infinitelog_t.AbstractInfiniteLogState.) Int
)
(declare-fun pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc (pmemlog!logimpl_v.PersistentHeader.)
 Int
)
(declare-fun pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (pmemlog!logimpl_v.PersistentHeader.)
 pmemlog!logimpl_v.PersistentHeaderMetadata.
)
(declare-fun pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head
 (pmemlog!logimpl_v.PersistentHeaderMetadata.) Int
)
(declare-fun pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail
 (pmemlog!logimpl_v.PersistentHeaderMetadata.) Int
)
(declare-fun pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
 (pmemlog!logimpl_v.PersistentHeaderMetadata.) Int
)
(declare-fun pmemlog!logimpl_v.HeaderView./HeaderView/header1 (pmemlog!logimpl_v.HeaderView.)
 pmemlog!logimpl_v.PersistentHeader.
)
(declare-fun pmemlog!logimpl_v.HeaderView./HeaderView/header2 (pmemlog!logimpl_v.HeaderView.)
 pmemlog!logimpl_v.PersistentHeader.
)
(declare-fun pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/incorruptible_bool
 (pmemlog!logimpl_v.UntrustedLogImpl.) Int
)
(declare-fun pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/header_crc (pmemlog!logimpl_v.UntrustedLogImpl.)
 Int
)
(declare-fun pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/head (pmemlog!logimpl_v.UntrustedLogImpl.)
 Int
)
(declare-fun pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/tail (pmemlog!logimpl_v.UntrustedLogImpl.)
 Int
)
(declare-fun pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/log_size (pmemlog!logimpl_v.UntrustedLogImpl.)
 Int
)
(declare-fun pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/required_space
 (pmemlog!main_t.InfiniteLogErr.) Int
)
(declare-fun pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/head (pmemlog!main_t.InfiniteLogErr.)
 Int
)
(declare-fun pmemlog!main_t.InfiniteLogErr./CantReadPastTail/tail (pmemlog!main_t.InfiniteLogErr.)
 Int
)
(declare-fun pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/available_space
 (pmemlog!main_t.InfiniteLogErr.) Int
)
(declare-fun pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/head
 (pmemlog!main_t.InfiniteLogErr.) Int
)
(declare-fun pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/tail
 (pmemlog!main_t.InfiniteLogErr.) Int
)
(declare-fun pmemlog!pmemspec_t.PersistentMemoryConstants./PersistentMemoryConstants/impervious_to_corruption
 (pmemlog!pmemspec_t.PersistentMemoryConstants.) Bool
)
(declare-fun tuple%2./tuple%2/0 (tuple%2.) Poly)
(declare-fun tuple%2./tuple%2/1 (tuple%2.) Poly)
(declare-fun tuple%3./tuple%3/0 (tuple%3.) Poly)
(declare-fun tuple%3./tuple%3/1 (tuple%3.) Poly)
(declare-fun tuple%3./tuple%3/2 (tuple%3.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%core!option.Option. (Dcr Type) Type)
(declare-fun TYPE%core!result.Result. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%alloc!vec.Vec. (Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-fun TYPE%vstd!set.Set. (Dcr Type) Type)
(declare-const TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState. Type)
(declare-const TYPE%pmemlog!logimpl_v.PersistentHeader. Type)
(declare-const TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata. Type)
(declare-const TYPE%pmemlog!logimpl_v.HeaderView. Type)
(declare-const TYPE%pmemlog!logimpl_v.UntrustedLogImpl. Type)
(declare-const TYPE%pmemlog!main_t.InfiniteLogErr. Type)
(declare-const TYPE%pmemlog!pmemspec_t.PersistentMemoryConstants. Type)
(declare-fun TYPE%pmemlog!pmemspec_t.WriteRestrictedPersistentMemory. (Dcr Type Dcr
  Type
 ) Type
)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%tuple%3. (Dcr Type Dcr Type Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%alloc!vec.Vec<u8./allocator_global%.>. (alloc!vec.Vec<u8./allocator_global%.>.)
 Poly
)
(declare-fun %Poly%alloc!vec.Vec<u8./allocator_global%.>. (Poly) alloc!vec.Vec<u8./allocator_global%.>.)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<int.>. (vstd!seq.Seq<int.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<int.>. (Poly) vstd!seq.Seq<int.>.)
(declare-fun Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq<u8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u8.>. (Poly) vstd!seq.Seq<u8.>.)
(declare-fun Poly%vstd!set.Set<int.>. (vstd!set.Set<int.>.) Poly)
(declare-fun %Poly%vstd!set.Set<int.>. (Poly) vstd!set.Set<int.>.)
(declare-fun Poly%slice%<u8.>. (slice%<u8.>.) Poly)
(declare-fun %Poly%slice%<u8.>. (Poly) slice%<u8.>.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%core!option.Option. (core!option.Option.) Poly)
(declare-fun %Poly%core!option.Option. (Poly) core!option.Option.)
(declare-fun Poly%core!result.Result. (core!result.Result.) Poly)
(declare-fun %Poly%core!result.Result. (Poly) core!result.Result.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. (pmemlog!infinitelog_t.AbstractInfiniteLogState.)
 Poly
)
(declare-fun %Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. (Poly) pmemlog!infinitelog_t.AbstractInfiniteLogState.)
(declare-fun Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.PersistentHeader.)
 Poly
)
(declare-fun %Poly%pmemlog!logimpl_v.PersistentHeader. (Poly) pmemlog!logimpl_v.PersistentHeader.)
(declare-fun Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (pmemlog!logimpl_v.PersistentHeaderMetadata.)
 Poly
)
(declare-fun %Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly) pmemlog!logimpl_v.PersistentHeaderMetadata.)
(declare-fun Poly%pmemlog!logimpl_v.HeaderView. (pmemlog!logimpl_v.HeaderView.) Poly)
(declare-fun %Poly%pmemlog!logimpl_v.HeaderView. (Poly) pmemlog!logimpl_v.HeaderView.)
(declare-fun Poly%pmemlog!logimpl_v.UntrustedLogImpl. (pmemlog!logimpl_v.UntrustedLogImpl.)
 Poly
)
(declare-fun %Poly%pmemlog!logimpl_v.UntrustedLogImpl. (Poly) pmemlog!logimpl_v.UntrustedLogImpl.)
(declare-fun Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr.)
 Poly
)
(declare-fun %Poly%pmemlog!main_t.InfiniteLogErr. (Poly) pmemlog!main_t.InfiniteLogErr.)
(declare-fun Poly%pmemlog!pmemspec_t.PersistentMemoryConstants. (pmemlog!pmemspec_t.PersistentMemoryConstants.)
 Poly
)
(declare-fun %Poly%pmemlog!pmemspec_t.PersistentMemoryConstants. (Poly) pmemlog!pmemspec_t.PersistentMemoryConstants.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%2. (tuple%2.) Poly)
(declare-fun %Poly%tuple%2. (Poly) tuple%2.)
(declare-fun Poly%tuple%3. (tuple%3.) Poly)
(declare-fun %Poly%tuple%3. (Poly) tuple%3.)
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%fun%1. (Poly%fun%1. x)))
   :pattern ((Poly%fun%1. x))
   :qid internal_crate__fun__1_box_axiom_definition
   :skolemid skolem_internal_crate__fun__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%fun%1. (%Poly%fun%1. x)))
   )
   :pattern ((has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__fun__1_unbox_axiom_definition
)))
(declare-fun %%apply%%0 (%%Function%% Poly) Poly)
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x %%Function%%)) (!
   (=>
    (forall ((T%0 Poly)) (!
      (=>
       (has_type T%0 T%0&)
       (has_type (%%apply%%0 x T%0) T%1&)
      )
      :pattern ((has_type (%%apply%%0 x T%0) T%1&))
      :qid internal_crate__fun__1_constructor_inner_definition
      :skolemid skolem_internal_crate__fun__1_constructor_inner_definition
    ))
    (has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
   )
   :pattern ((has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_constructor_definition
   :skolemid skolem_internal_crate__fun__1_constructor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (has_type (%%apply%%0 x T%0) T%1&)
   )
   :pattern ((%%apply%%0 x T%0) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&.
      T%1&
   )))
   :qid internal_crate__fun__1_apply_definition
   :skolemid skolem_internal_crate__fun__1_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (height_lt (height (%%apply%%0 x T%0)) (height (fun_from_recursive_field (Poly%fun%1.
        (mk_fun x)
   )))))
   :pattern ((height (%%apply%%0 x T%0)) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_crate__fun__1_height_apply_definition
   :skolemid skolem_internal_crate__fun__1_height_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (forall ((T%0 Poly)) (!
       (=>
        (has_type T%0 T%0&)
        (ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1. y) T%0))
       )
       :pattern ((ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1.
           y
          ) T%0
       )))
       :qid internal_crate__fun__1_inner_ext_equal_definition
       :skolemid skolem_internal_crate__fun__1_inner_ext_equal_definition
    )))
    (ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_crate__fun__1_ext_equal_definition
   :skolemid skolem_internal_crate__fun__1_ext_equal_definition
)))
(assert
 (forall ((x alloc!vec.Vec<u8./allocator_global%.>.)) (!
   (= x (%Poly%alloc!vec.Vec<u8./allocator_global%.>. (Poly%alloc!vec.Vec<u8./allocator_global%.>.
      x
   )))
   :pattern ((Poly%alloc!vec.Vec<u8./allocator_global%.>. x))
   :qid internal_alloc__vec__Vec<u8./allocator_global__.>_box_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<u8./allocator_global__.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%alloc!vec.Vec. $ (UINT 8) $ ALLOCATOR_GLOBAL))
    (= x (Poly%alloc!vec.Vec<u8./allocator_global%.>. (%Poly%alloc!vec.Vec<u8./allocator_global%.>.
       x
   ))))
   :pattern ((has_type x (TYPE%alloc!vec.Vec. $ (UINT 8) $ ALLOCATOR_GLOBAL)))
   :qid internal_alloc__vec__Vec<u8./allocator_global__.>_unbox_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<u8./allocator_global__.>_unbox_axiom_definition
)))
(assert
 (forall ((x alloc!vec.Vec<u8./allocator_global%.>.)) (!
   (has_type (Poly%alloc!vec.Vec<u8./allocator_global%.>. x) (TYPE%alloc!vec.Vec. $ (UINT
      8
     ) $ ALLOCATOR_GLOBAL
   ))
   :pattern ((has_type (Poly%alloc!vec.Vec<u8./allocator_global%.>. x) (TYPE%alloc!vec.Vec.
      $ (UINT 8) $ ALLOCATOR_GLOBAL
   )))
   :qid internal_alloc__vec__Vec<u8./allocator_global__.>_has_type_always_definition
   :skolemid skolem_internal_alloc__vec__Vec<u8./allocator_global__.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (= x (%Poly%vstd!raw_ptr.Provenance. (Poly%vstd!raw_ptr.Provenance. x)))
   :pattern ((Poly%vstd!raw_ptr.Provenance. x))
   :qid internal_vstd__raw_ptr__Provenance_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%vstd!raw_ptr.Provenance.)
    (= x (Poly%vstd!raw_ptr.Provenance. (%Poly%vstd!raw_ptr.Provenance. x)))
   )
   :pattern ((has_type x TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.)
   :pattern ((has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_has_type_always_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<int.>.)) (!
   (= x (%Poly%vstd!seq.Seq<int.>. (Poly%vstd!seq.Seq<int.>. x)))
   :pattern ((Poly%vstd!seq.Seq<int.>. x))
   :qid internal_vstd__seq__Seq<int.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<int.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ INT))
    (= x (Poly%vstd!seq.Seq<int.>. (%Poly%vstd!seq.Seq<int.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ INT)))
   :qid internal_vstd__seq__Seq<int.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<int.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<int.>.)) (!
   (has_type (Poly%vstd!seq.Seq<int.>. x) (TYPE%vstd!seq.Seq. $ INT))
   :pattern ((has_type (Poly%vstd!seq.Seq<int.>. x) (TYPE%vstd!seq.Seq. $ INT)))
   :qid internal_vstd__seq__Seq<int.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<int.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u8.>.)) (!
   (= x (%Poly%vstd!seq.Seq<u8.>. (Poly%vstd!seq.Seq<u8.>. x)))
   :pattern ((Poly%vstd!seq.Seq<u8.>. x))
   :qid internal_vstd__seq__Seq<u8.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (= x (Poly%vstd!seq.Seq<u8.>. (%Poly%vstd!seq.Seq<u8.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (UINT 8))))
   :qid internal_vstd__seq__Seq<u8.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u8.>.)) (!
   (has_type (Poly%vstd!seq.Seq<u8.>. x) (TYPE%vstd!seq.Seq. $ (UINT 8)))
   :pattern ((has_type (Poly%vstd!seq.Seq<u8.>. x) (TYPE%vstd!seq.Seq. $ (UINT 8))))
   :qid internal_vstd__seq__Seq<u8.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!set.Set<int.>.)) (!
   (= x (%Poly%vstd!set.Set<int.>. (Poly%vstd!set.Set<int.>. x)))
   :pattern ((Poly%vstd!set.Set<int.>. x))
   :qid internal_vstd__set__Set<int.>_box_axiom_definition
   :skolemid skolem_internal_vstd__set__Set<int.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!set.Set. $ INT))
    (= x (Poly%vstd!set.Set<int.>. (%Poly%vstd!set.Set<int.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!set.Set. $ INT)))
   :qid internal_vstd__set__Set<int.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__set__Set<int.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!set.Set<int.>.)) (!
   (has_type (Poly%vstd!set.Set<int.>. x) (TYPE%vstd!set.Set. $ INT))
   :pattern ((has_type (Poly%vstd!set.Set<int.>. x) (TYPE%vstd!set.Set. $ INT)))
   :qid internal_vstd__set__Set<int.>_has_type_always_definition
   :skolemid skolem_internal_vstd__set__Set<int.>_has_type_always_definition
)))
(assert
 (forall ((x slice%<u8.>.)) (!
   (= x (%Poly%slice%<u8.>. (Poly%slice%<u8.>. x)))
   :pattern ((Poly%slice%<u8.>. x))
   :qid internal_crate__slice__<u8.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<u8.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ (UINT 8)))
    (= x (Poly%slice%<u8.>. (%Poly%slice%<u8.>. x)))
   )
   :pattern ((has_type x (SLICE $ (UINT 8))))
   :qid internal_crate__slice__<u8.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<u8.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<u8.>.)) (!
   (has_type (Poly%slice%<u8.>. x) (SLICE $ (UINT 8)))
   :pattern ((has_type (Poly%slice%<u8.>. x) (SLICE $ (UINT 8))))
   :qid internal_crate__slice__<u8.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<u8.>_has_type_always_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (= x (%Poly%allocator_global%. (Poly%allocator_global%. x)))
   :pattern ((Poly%allocator_global%. x))
   :qid internal_crate__allocator_global___box_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ALLOCATOR_GLOBAL)
    (= x (Poly%allocator_global%. (%Poly%allocator_global%. x)))
   )
   :pattern ((has_type x ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___unbox_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___unbox_axiom_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL)
   :pattern ((has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___has_type_always_definition
   :skolemid skolem_internal_crate__allocator_global___has_type_always_definition
)))
(assert
 (forall ((x core!option.Option.)) (!
   (= x (%Poly%core!option.Option. (Poly%core!option.Option. x)))
   :pattern ((Poly%core!option.Option. x))
   :qid internal_core__option__Option_box_axiom_definition
   :skolemid skolem_internal_core__option__Option_box_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!option.Option. V&. V&))
    (= x (Poly%core!option.Option. (%Poly%core!option.Option. x)))
   )
   :pattern ((has_type x (TYPE%core!option.Option. V&. V&)))
   :qid internal_core__option__Option_unbox_axiom_definition
   :skolemid skolem_internal_core__option__Option_unbox_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type)) (!
   (has_type (Poly%core!option.Option. core!option.Option./None) (TYPE%core!option.Option.
     V&. V&
   ))
   :pattern ((has_type (Poly%core!option.Option. core!option.Option./None) (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./None_constructor_definition
   :skolemid skolem_internal_core!option.Option./None_constructor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (_0! Poly)) (!
   (=>
    (has_type _0! V&)
    (has_type (Poly%core!option.Option. (core!option.Option./Some _0!)) (TYPE%core!option.Option.
      V&. V&
   )))
   :pattern ((has_type (Poly%core!option.Option. (core!option.Option./Some _0!)) (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./Some_constructor_definition
   :skolemid skolem_internal_core!option.Option./Some_constructor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x core!option.Option.)) (!
   (=>
    (is-core!option.Option./Some x)
    (= (core!option.Option./Some/0 V&. V& x) (core!option.Option./Some/?0 x))
   )
   :pattern ((core!option.Option./Some/0 V&. V& x))
   :qid internal_core!option.Option./Some/0_accessor_definition
   :skolemid skolem_internal_core!option.Option./Some/0_accessor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!option.Option. V&. V&))
    (has_type (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x)) V&)
   )
   :pattern ((core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x)) (has_type
     x (TYPE%core!option.Option. V&. V&)
   ))
   :qid internal_core!option.Option./Some/0_invariant_definition
   :skolemid skolem_internal_core!option.Option./Some/0_invariant_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x core!option.Option.)) (!
   (=>
    (is-core!option.Option./Some x)
    (height_lt (height (core!option.Option./Some/0 V&. V& x)) (height (Poly%core!option.Option.
       x
   ))))
   :pattern ((height (core!option.Option./Some/0 V&. V& x)))
   :qid prelude_datatype_height_core!option.Option./Some/0
   :skolemid skolem_prelude_datatype_height_core!option.Option./Some/0
)))
(assert
 (forall ((V&. Dcr) (V& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%core!option.Option. V&. V&))
     (has_type y (TYPE%core!option.Option. V&. V&))
     (is-core!option.Option./None (%Poly%core!option.Option. x))
     (is-core!option.Option./None (%Poly%core!option.Option. y))
    )
    (ext_eq deep (TYPE%core!option.Option. V&. V&) x y)
   )
   :pattern ((ext_eq deep (TYPE%core!option.Option. V&. V&) x y))
   :qid internal_core!option.Option./None_ext_equal_definition
   :skolemid skolem_internal_core!option.Option./None_ext_equal_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%core!option.Option. V&. V&))
     (has_type y (TYPE%core!option.Option. V&. V&))
     (is-core!option.Option./Some (%Poly%core!option.Option. x))
     (is-core!option.Option./Some (%Poly%core!option.Option. y))
     (ext_eq deep V& (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x))
      (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. y))
    ))
    (ext_eq deep (TYPE%core!option.Option. V&. V&) x y)
   )
   :pattern ((ext_eq deep (TYPE%core!option.Option. V&. V&) x y))
   :qid internal_core!option.Option./Some_ext_equal_definition
   :skolemid skolem_internal_core!option.Option./Some_ext_equal_definition
)))
(assert
 (forall ((x core!result.Result.)) (!
   (= x (%Poly%core!result.Result. (Poly%core!result.Result. x)))
   :pattern ((Poly%core!result.Result. x))
   :qid internal_core__result__Result_box_axiom_definition
   :skolemid skolem_internal_core__result__Result_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (= x (Poly%core!result.Result. (%Poly%core!result.Result. x)))
   )
   :pattern ((has_type x (TYPE%core!result.Result. T&. T& E&. E&)))
   :qid internal_core__result__Result_unbox_axiom_definition
   :skolemid skolem_internal_core__result__Result_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (_0! Poly)) (!
   (=>
    (has_type _0! T&)
    (has_type (Poly%core!result.Result. (core!result.Result./Ok _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((has_type (Poly%core!result.Result. (core!result.Result./Ok _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :qid internal_core!result.Result./Ok_constructor_definition
   :skolemid skolem_internal_core!result.Result./Ok_constructor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Ok x)
    (= (core!result.Result./Ok/0 T&. T& E&. E& x) (core!result.Result./Ok/?0 x))
   )
   :pattern ((core!result.Result./Ok/0 T&. T& E&. E& x))
   :qid internal_core!result.Result./Ok/0_accessor_definition
   :skolemid skolem_internal_core!result.Result./Ok/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (has_type (core!result.Result./Ok/0 T&. T& E&. E& (%Poly%core!result.Result. x)) T&)
   )
   :pattern ((core!result.Result./Ok/0 T&. T& E&. E& (%Poly%core!result.Result. x)) (
     has_type x (TYPE%core!result.Result. T&. T& E&. E&)
   ))
   :qid internal_core!result.Result./Ok/0_invariant_definition
   :skolemid skolem_internal_core!result.Result./Ok/0_invariant_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (_0! Poly)) (!
   (=>
    (has_type _0! E&)
    (has_type (Poly%core!result.Result. (core!result.Result./Err _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((has_type (Poly%core!result.Result. (core!result.Result./Err _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :qid internal_core!result.Result./Err_constructor_definition
   :skolemid skolem_internal_core!result.Result./Err_constructor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Err x)
    (= (core!result.Result./Err/0 T&. T& E&. E& x) (core!result.Result./Err/?0 x))
   )
   :pattern ((core!result.Result./Err/0 T&. T& E&. E& x))
   :qid internal_core!result.Result./Err/0_accessor_definition
   :skolemid skolem_internal_core!result.Result./Err/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (has_type (core!result.Result./Err/0 T&. T& E&. E& (%Poly%core!result.Result. x))
     E&
   ))
   :pattern ((core!result.Result./Err/0 T&. T& E&. E& (%Poly%core!result.Result. x))
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
   )
   :qid internal_core!result.Result./Err/0_invariant_definition
   :skolemid skolem_internal_core!result.Result./Err/0_invariant_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Ok x)
    (height_lt (height (core!result.Result./Ok/0 T&. T& E&. E& x)) (height (Poly%core!result.Result.
       x
   ))))
   :pattern ((height (core!result.Result./Ok/0 T&. T& E&. E& x)))
   :qid prelude_datatype_height_core!result.Result./Ok/0
   :skolemid skolem_prelude_datatype_height_core!result.Result./Ok/0
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Err x)
    (height_lt (height (core!result.Result./Err/0 T&. T& E&. E& x)) (height (Poly%core!result.Result.
       x
   ))))
   :pattern ((height (core!result.Result./Err/0 T&. T& E&. E& x)))
   :qid prelude_datatype_height_core!result.Result./Err/0
   :skolemid skolem_prelude_datatype_height_core!result.Result./Err/0
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= x (%Poly%vstd!raw_ptr.PtrData. (Poly%vstd!raw_ptr.PtrData. x)))
   :pattern ((Poly%vstd!raw_ptr.PtrData. x))
   :qid internal_vstd__raw_ptr__PtrData_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (= x (Poly%vstd!raw_ptr.PtrData. (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&)))
   :qid internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_addr! Int) (_provenance! vstd!raw_ptr.Provenance.) (
    _metadata! Poly
   )
  ) (!
   (=>
    (and
     (uInv SZ _addr!)
     (has_type _metadata! (pointee_metadata% T&.))
    )
    (has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr! _provenance!
       _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :pattern ((has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr!
       _provenance! _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/addr x) (vstd!raw_ptr.PtrData./PtrData/?addr x))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (uInv SZ (vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)) (has_type
     x (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/provenance x) (vstd!raw_ptr.PtrData./PtrData/?provenance
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/provenance x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/metadata x) (vstd!raw_ptr.PtrData./PtrData/?metadata
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
     (pointee_metadata% T&.)
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   )
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
)))
(assert
 (forall ((x pmemlog!infinitelog_t.AbstractInfiniteLogState.)) (!
   (= x (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. (Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState.
      x
   )))
   :pattern ((Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. x))
   :qid internal_pmemlog__infinitelog_t__AbstractInfiniteLogState_box_axiom_definition
   :skolemid skolem_internal_pmemlog__infinitelog_t__AbstractInfiniteLogState_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState.)
    (= x (Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState.
       x
   ))))
   :pattern ((has_type x TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState.))
   :qid internal_pmemlog__infinitelog_t__AbstractInfiniteLogState_unbox_axiom_definition
   :skolemid skolem_internal_pmemlog__infinitelog_t__AbstractInfiniteLogState_unbox_axiom_definition
)))
(assert
 (forall ((x pmemlog!infinitelog_t.AbstractInfiniteLogState.)) (!
   (= (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head x)
    (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/?head x)
   )
   :pattern ((pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head
     x
   ))
   :qid internal_pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head_accessor_definition
   :skolemid skolem_internal_pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head_accessor_definition
)))
(assert
 (forall ((x pmemlog!infinitelog_t.AbstractInfiniteLogState.)) (!
   (= (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log x)
    (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/?log x)
   )
   :pattern ((pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log
     x
   ))
   :qid internal_pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log_accessor_definition
   :skolemid skolem_internal_pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log_accessor_definition
)))
(assert
 (forall ((x pmemlog!infinitelog_t.AbstractInfiniteLogState.)) (!
   (= (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/capacity
     x
    ) (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/?capacity
     x
   ))
   :pattern ((pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/capacity
     x
   ))
   :qid internal_pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/capacity_accessor_definition
   :skolemid skolem_internal_pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/capacity_accessor_definition
)))
(assert
 (forall ((x pmemlog!infinitelog_t.AbstractInfiniteLogState.)) (!
   (has_type (Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. x) TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState.)
   :pattern ((has_type (Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. x) TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState.))
   :qid internal_pmemlog__infinitelog_t__AbstractInfiniteLogState_has_type_always_definition
   :skolemid skolem_internal_pmemlog__infinitelog_t__AbstractInfiniteLogState_has_type_always_definition
)))
(assert
 (forall ((deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState.)
     (has_type y TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState.)
     (= (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head (
        %Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. x
       )
      ) (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head (
        %Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. y
     )))
     (ext_eq deep (TYPE%vstd!seq.Seq. $ (UINT 8)) (Poly%vstd!seq.Seq<u8.>. (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log
        (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. x)
       )
      ) (Poly%vstd!seq.Seq<u8.>. (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log
        (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. y)
     )))
     (= (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/capacity
       (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. x)
      ) (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/capacity
       (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. y)
    )))
    (ext_eq deep TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState. x y)
   )
   :pattern ((ext_eq deep TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState. x y))
   :qid internal_pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState_ext_equal_definition
   :skolemid skolem_internal_pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState_ext_equal_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.PersistentHeader.)) (!
   (= x (%Poly%pmemlog!logimpl_v.PersistentHeader. (Poly%pmemlog!logimpl_v.PersistentHeader.
      x
   )))
   :pattern ((Poly%pmemlog!logimpl_v.PersistentHeader. x))
   :qid internal_pmemlog__logimpl_v__PersistentHeader_box_axiom_definition
   :skolemid skolem_internal_pmemlog__logimpl_v__PersistentHeader_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.PersistentHeader.)
    (= x (Poly%pmemlog!logimpl_v.PersistentHeader. (%Poly%pmemlog!logimpl_v.PersistentHeader.
       x
   ))))
   :pattern ((has_type x TYPE%pmemlog!logimpl_v.PersistentHeader.))
   :qid internal_pmemlog__logimpl_v__PersistentHeader_unbox_axiom_definition
   :skolemid skolem_internal_pmemlog__logimpl_v__PersistentHeader_unbox_axiom_definition
)))
(assert
 (forall ((_crc! Int) (_metadata! pmemlog!logimpl_v.PersistentHeaderMetadata.)) (!
   (=>
    (and
     (uInv 64 _crc!)
     (has_type (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. _metadata!) TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
    )
    (has_type (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.PersistentHeader./PersistentHeader
       _crc! _metadata!
      )
     ) TYPE%pmemlog!logimpl_v.PersistentHeader.
   ))
   :pattern ((has_type (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.PersistentHeader./PersistentHeader
       _crc! _metadata!
      )
     ) TYPE%pmemlog!logimpl_v.PersistentHeader.
   ))
   :qid internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader_constructor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader_constructor_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.PersistentHeader.)) (!
   (= (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc x) (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/?crc
     x
   ))
   :pattern ((pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc x))
   :qid internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.PersistentHeader.)
    (uInv 64 (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc (%Poly%pmemlog!logimpl_v.PersistentHeader.
       x
   ))))
   :pattern ((pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc (%Poly%pmemlog!logimpl_v.PersistentHeader.
      x
     )
    ) (has_type x TYPE%pmemlog!logimpl_v.PersistentHeader.)
   )
   :qid internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc_invariant_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.PersistentHeader.)) (!
   (= (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata x) (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/?metadata
     x
   ))
   :pattern ((pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata x))
   :qid internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.PersistentHeader.)
    (has_type (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata
       (%Poly%pmemlog!logimpl_v.PersistentHeader. x)
      )
     ) TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.
   ))
   :pattern ((pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
      x
     )
    ) (has_type x TYPE%pmemlog!logimpl_v.PersistentHeader.)
   )
   :qid internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata_invariant_definition
)))
(assert
 (forall ((deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x TYPE%pmemlog!logimpl_v.PersistentHeader.)
     (has_type y TYPE%pmemlog!logimpl_v.PersistentHeader.)
     (= (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc (%Poly%pmemlog!logimpl_v.PersistentHeader.
        x
       )
      ) (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc (%Poly%pmemlog!logimpl_v.PersistentHeader.
        y
     )))
     (ext_eq deep TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
       (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
         x
       ))
      ) (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata
        (%Poly%pmemlog!logimpl_v.PersistentHeader. y)
    ))))
    (ext_eq deep TYPE%pmemlog!logimpl_v.PersistentHeader. x y)
   )
   :pattern ((ext_eq deep TYPE%pmemlog!logimpl_v.PersistentHeader. x y))
   :qid internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader_ext_equal_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeader./PersistentHeader_ext_equal_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.PersistentHeaderMetadata.)) (!
   (= x (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
      x
   )))
   :pattern ((Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. x))
   :qid internal_pmemlog__logimpl_v__PersistentHeaderMetadata_box_axiom_definition
   :skolemid skolem_internal_pmemlog__logimpl_v__PersistentHeaderMetadata_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
    (= x (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
       x
   ))))
   :pattern ((has_type x TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.))
   :qid internal_pmemlog__logimpl_v__PersistentHeaderMetadata_unbox_axiom_definition
   :skolemid skolem_internal_pmemlog__logimpl_v__PersistentHeaderMetadata_unbox_axiom_definition
)))
(assert
 (forall ((_head! Int) (_tail! Int) (_log_size! Int)) (!
   (=>
    (and
     (uInv 64 _head!)
     (uInv 64 _tail!)
     (uInv 64 _log_size!)
    )
    (has_type (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata
       _head! _tail! _log_size!
      )
     ) TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.
   ))
   :pattern ((has_type (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata
       _head! _tail! _log_size!
      )
     ) TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.
   ))
   :qid internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata_constructor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata_constructor_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.PersistentHeaderMetadata.)) (!
   (= (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head x) (
     pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/?head x
   ))
   :pattern ((pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head
     x
   ))
   :qid internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
    (uInv 64 (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head
      (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. x)
   )))
   :pattern ((pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head
     (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. x)
    ) (has_type x TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
   )
   :qid internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head_invariant_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.PersistentHeaderMetadata.)) (!
   (= (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail x) (
     pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/?tail x
   ))
   :pattern ((pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail
     x
   ))
   :qid internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
    (uInv 64 (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail
      (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. x)
   )))
   :pattern ((pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail
     (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. x)
    ) (has_type x TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
   )
   :qid internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail_invariant_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.PersistentHeaderMetadata.)) (!
   (= (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size x)
    (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/?log_size x)
   )
   :pattern ((pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
     x
   ))
   :qid internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
    (uInv 64 (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
      (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. x)
   )))
   :pattern ((pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
     (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. x)
    ) (has_type x TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
   )
   :qid internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size_invariant_definition
)))
(assert
 (forall ((deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
     (has_type y TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
     (= (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
        x
       )
      ) (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
        y
     )))
     (= (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
        x
       )
      ) (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
        y
     )))
     (= (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size (
        %Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. x
       )
      ) (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size (
        %Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. y
    ))))
    (ext_eq deep TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata. x y)
   )
   :pattern ((ext_eq deep TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata. x y))
   :qid internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata_ext_equal_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata_ext_equal_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.HeaderView.)) (!
   (= x (%Poly%pmemlog!logimpl_v.HeaderView. (Poly%pmemlog!logimpl_v.HeaderView. x)))
   :pattern ((Poly%pmemlog!logimpl_v.HeaderView. x))
   :qid internal_pmemlog__logimpl_v__HeaderView_box_axiom_definition
   :skolemid skolem_internal_pmemlog__logimpl_v__HeaderView_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.HeaderView.)
    (= x (Poly%pmemlog!logimpl_v.HeaderView. (%Poly%pmemlog!logimpl_v.HeaderView. x)))
   )
   :pattern ((has_type x TYPE%pmemlog!logimpl_v.HeaderView.))
   :qid internal_pmemlog__logimpl_v__HeaderView_unbox_axiom_definition
   :skolemid skolem_internal_pmemlog__logimpl_v__HeaderView_unbox_axiom_definition
)))
(assert
 (forall ((_header1! pmemlog!logimpl_v.PersistentHeader.) (_header2! pmemlog!logimpl_v.PersistentHeader.))
  (!
   (=>
    (and
     (has_type (Poly%pmemlog!logimpl_v.PersistentHeader. _header1!) TYPE%pmemlog!logimpl_v.PersistentHeader.)
     (has_type (Poly%pmemlog!logimpl_v.PersistentHeader. _header2!) TYPE%pmemlog!logimpl_v.PersistentHeader.)
    )
    (has_type (Poly%pmemlog!logimpl_v.HeaderView. (pmemlog!logimpl_v.HeaderView./HeaderView
       _header1! _header2!
      )
     ) TYPE%pmemlog!logimpl_v.HeaderView.
   ))
   :pattern ((has_type (Poly%pmemlog!logimpl_v.HeaderView. (pmemlog!logimpl_v.HeaderView./HeaderView
       _header1! _header2!
      )
     ) TYPE%pmemlog!logimpl_v.HeaderView.
   ))
   :qid internal_pmemlog!logimpl_v.HeaderView./HeaderView_constructor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.HeaderView./HeaderView_constructor_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.HeaderView.)) (!
   (= (pmemlog!logimpl_v.HeaderView./HeaderView/header1 x) (pmemlog!logimpl_v.HeaderView./HeaderView/?header1
     x
   ))
   :pattern ((pmemlog!logimpl_v.HeaderView./HeaderView/header1 x))
   :qid internal_pmemlog!logimpl_v.HeaderView./HeaderView/header1_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.HeaderView./HeaderView/header1_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.HeaderView.)
    (has_type (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.HeaderView./HeaderView/header1
       (%Poly%pmemlog!logimpl_v.HeaderView. x)
      )
     ) TYPE%pmemlog!logimpl_v.PersistentHeader.
   ))
   :pattern ((pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
      x
     )
    ) (has_type x TYPE%pmemlog!logimpl_v.HeaderView.)
   )
   :qid internal_pmemlog!logimpl_v.HeaderView./HeaderView/header1_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.HeaderView./HeaderView/header1_invariant_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.HeaderView.)) (!
   (= (pmemlog!logimpl_v.HeaderView./HeaderView/header2 x) (pmemlog!logimpl_v.HeaderView./HeaderView/?header2
     x
   ))
   :pattern ((pmemlog!logimpl_v.HeaderView./HeaderView/header2 x))
   :qid internal_pmemlog!logimpl_v.HeaderView./HeaderView/header2_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.HeaderView./HeaderView/header2_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.HeaderView.)
    (has_type (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.HeaderView./HeaderView/header2
       (%Poly%pmemlog!logimpl_v.HeaderView. x)
      )
     ) TYPE%pmemlog!logimpl_v.PersistentHeader.
   ))
   :pattern ((pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
      x
     )
    ) (has_type x TYPE%pmemlog!logimpl_v.HeaderView.)
   )
   :qid internal_pmemlog!logimpl_v.HeaderView./HeaderView/header2_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.HeaderView./HeaderView/header2_invariant_definition
)))
(assert
 (forall ((deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x TYPE%pmemlog!logimpl_v.HeaderView.)
     (has_type y TYPE%pmemlog!logimpl_v.HeaderView.)
     (ext_eq deep TYPE%pmemlog!logimpl_v.PersistentHeader. (Poly%pmemlog!logimpl_v.PersistentHeader.
       (pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
         x
       ))
      ) (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.HeaderView./HeaderView/header1
        (%Poly%pmemlog!logimpl_v.HeaderView. y)
     )))
     (ext_eq deep TYPE%pmemlog!logimpl_v.PersistentHeader. (Poly%pmemlog!logimpl_v.PersistentHeader.
       (pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
         x
       ))
      ) (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.HeaderView./HeaderView/header2
        (%Poly%pmemlog!logimpl_v.HeaderView. y)
    ))))
    (ext_eq deep TYPE%pmemlog!logimpl_v.HeaderView. x y)
   )
   :pattern ((ext_eq deep TYPE%pmemlog!logimpl_v.HeaderView. x y))
   :qid internal_pmemlog!logimpl_v.HeaderView./HeaderView_ext_equal_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.HeaderView./HeaderView_ext_equal_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.UntrustedLogImpl.)) (!
   (= x (%Poly%pmemlog!logimpl_v.UntrustedLogImpl. (Poly%pmemlog!logimpl_v.UntrustedLogImpl.
      x
   )))
   :pattern ((Poly%pmemlog!logimpl_v.UntrustedLogImpl. x))
   :qid internal_pmemlog__logimpl_v__UntrustedLogImpl_box_axiom_definition
   :skolemid skolem_internal_pmemlog__logimpl_v__UntrustedLogImpl_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
    (= x (Poly%pmemlog!logimpl_v.UntrustedLogImpl. (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
       x
   ))))
   :pattern ((has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.))
   :qid internal_pmemlog__logimpl_v__UntrustedLogImpl_unbox_axiom_definition
   :skolemid skolem_internal_pmemlog__logimpl_v__UntrustedLogImpl_unbox_axiom_definition
)))
(assert
 (forall ((_incorruptible_bool! Int) (_header_crc! Int) (_head! Int) (_tail! Int) (_log_size!
    Int
   )
  ) (!
   (=>
    (and
     (uInv 64 _incorruptible_bool!)
     (uInv 64 _header_crc!)
     (uInv 64 _head!)
     (uInv 64 _tail!)
     (uInv 64 _log_size!)
    )
    (has_type (Poly%pmemlog!logimpl_v.UntrustedLogImpl. (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl
       _incorruptible_bool! _header_crc! _head! _tail! _log_size!
      )
     ) TYPE%pmemlog!logimpl_v.UntrustedLogImpl.
   ))
   :pattern ((has_type (Poly%pmemlog!logimpl_v.UntrustedLogImpl. (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl
       _incorruptible_bool! _header_crc! _head! _tail! _log_size!
      )
     ) TYPE%pmemlog!logimpl_v.UntrustedLogImpl.
   ))
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl_constructor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl_constructor_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.UntrustedLogImpl.)) (!
   (= (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/incorruptible_bool x) (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/?incorruptible_bool
     x
   ))
   :pattern ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/incorruptible_bool
     x
   ))
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/incorruptible_bool_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/incorruptible_bool_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
    (uInv 64 (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/incorruptible_bool (
       %Poly%pmemlog!logimpl_v.UntrustedLogImpl. x
   ))))
   :pattern ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/incorruptible_bool
     (%Poly%pmemlog!logimpl_v.UntrustedLogImpl. x)
    ) (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
   )
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/incorruptible_bool_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/incorruptible_bool_invariant_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.UntrustedLogImpl.)) (!
   (= (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/header_crc x) (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/?header_crc
     x
   ))
   :pattern ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/header_crc x))
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/header_crc_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/header_crc_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
    (uInv 64 (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/header_crc (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
       x
   ))))
   :pattern ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/header_crc (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
      x
     )
    ) (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
   )
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/header_crc_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/header_crc_invariant_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.UntrustedLogImpl.)) (!
   (= (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/head x) (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/?head
     x
   ))
   :pattern ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/head x))
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/head_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/head_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
    (uInv 64 (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/head (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
       x
   ))))
   :pattern ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/head (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
      x
     )
    ) (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
   )
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/head_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/head_invariant_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.UntrustedLogImpl.)) (!
   (= (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/tail x) (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/?tail
     x
   ))
   :pattern ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/tail x))
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/tail_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/tail_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
    (uInv 64 (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/tail (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
       x
   ))))
   :pattern ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/tail (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
      x
     )
    ) (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
   )
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/tail_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/tail_invariant_definition
)))
(assert
 (forall ((x pmemlog!logimpl_v.UntrustedLogImpl.)) (!
   (= (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/log_size x) (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/?log_size
     x
   ))
   :pattern ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/log_size x))
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/log_size_accessor_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/log_size_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
    (uInv 64 (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/log_size (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
       x
   ))))
   :pattern ((pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/log_size (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
      x
     )
    ) (has_type x TYPE%pmemlog!logimpl_v.UntrustedLogImpl.)
   )
   :qid internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/log_size_invariant_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/log_size_invariant_definition
)))
(assert
 (forall ((x pmemlog!main_t.InfiniteLogErr.)) (!
   (= x (%Poly%pmemlog!main_t.InfiniteLogErr. (Poly%pmemlog!main_t.InfiniteLogErr. x)))
   :pattern ((Poly%pmemlog!main_t.InfiniteLogErr. x))
   :qid internal_pmemlog__main_t__InfiniteLogErr_box_axiom_definition
   :skolemid skolem_internal_pmemlog__main_t__InfiniteLogErr_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
    (= x (Poly%pmemlog!main_t.InfiniteLogErr. (%Poly%pmemlog!main_t.InfiniteLogErr. x)))
   )
   :pattern ((has_type x TYPE%pmemlog!main_t.InfiniteLogErr.))
   :qid internal_pmemlog__main_t__InfiniteLogErr_unbox_axiom_definition
   :skolemid skolem_internal_pmemlog__main_t__InfiniteLogErr_unbox_axiom_definition
)))
(assert
 (forall ((_required_space! Int)) (!
   (=>
    (uInv 64 _required_space!)
    (has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup
       _required_space!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :pattern ((has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup
       _required_space!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :qid internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup_constructor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup_constructor_definition
)))
(assert
 (forall ((x pmemlog!main_t.InfiniteLogErr.)) (!
   (= (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/required_space x) (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/?required_space
     x
   ))
   :pattern ((pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/required_space
     x
   ))
   :qid internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/required_space_accessor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/required_space_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
    (uInv 64 (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/required_space (
       %Poly%pmemlog!main_t.InfiniteLogErr. x
   ))))
   :pattern ((pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/required_space
     (%Poly%pmemlog!main_t.InfiniteLogErr. x)
    ) (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
   )
   :qid internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/required_space_invariant_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForSetup/required_space_invariant_definition
)))
(assert
 (forall ((_head! Int)) (!
   (=>
    (uInv 64 _head!)
    (has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead
       _head!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :pattern ((has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead
       _head!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead_constructor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead_constructor_definition
)))
(assert
 (forall ((x pmemlog!main_t.InfiniteLogErr.)) (!
   (= (pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/head x) (pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/?head
     x
   ))
   :pattern ((pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/head x))
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/head_accessor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/head_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
    (uInv 64 (pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/head (%Poly%pmemlog!main_t.InfiniteLogErr.
       x
   ))))
   :pattern ((pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/head (%Poly%pmemlog!main_t.InfiniteLogErr.
      x
     )
    ) (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
   )
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/head_invariant_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantReadBeforeHead/head_invariant_definition
)))
(assert
 (forall ((_tail! Int)) (!
   (=>
    (uInv 64 _tail!)
    (has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./CantReadPastTail
       _tail!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :pattern ((has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./CantReadPastTail
       _tail!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantReadPastTail_constructor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantReadPastTail_constructor_definition
)))
(assert
 (forall ((x pmemlog!main_t.InfiniteLogErr.)) (!
   (= (pmemlog!main_t.InfiniteLogErr./CantReadPastTail/tail x) (pmemlog!main_t.InfiniteLogErr./CantReadPastTail/?tail
     x
   ))
   :pattern ((pmemlog!main_t.InfiniteLogErr./CantReadPastTail/tail x))
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantReadPastTail/tail_accessor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantReadPastTail/tail_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
    (uInv 64 (pmemlog!main_t.InfiniteLogErr./CantReadPastTail/tail (%Poly%pmemlog!main_t.InfiniteLogErr.
       x
   ))))
   :pattern ((pmemlog!main_t.InfiniteLogErr./CantReadPastTail/tail (%Poly%pmemlog!main_t.InfiniteLogErr.
      x
     )
    ) (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
   )
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantReadPastTail/tail_invariant_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantReadPastTail/tail_invariant_definition
)))
(assert
 (forall ((_available_space! Int)) (!
   (=>
    (uInv 64 _available_space!)
    (has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend
       _available_space!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :pattern ((has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend
       _available_space!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :qid internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend_constructor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend_constructor_definition
)))
(assert
 (forall ((x pmemlog!main_t.InfiniteLogErr.)) (!
   (= (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/available_space x) (
     pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/?available_space x
   ))
   :pattern ((pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/available_space
     x
   ))
   :qid internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/available_space_accessor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/available_space_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
    (uInv 64 (pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/available_space
      (%Poly%pmemlog!main_t.InfiniteLogErr. x)
   )))
   :pattern ((pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/available_space
     (%Poly%pmemlog!main_t.InfiniteLogErr. x)
    ) (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
   )
   :qid internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/available_space_invariant_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./InsufficientSpaceForAppend/available_space_invariant_definition
)))
(assert
 (has_type (Poly%pmemlog!main_t.InfiniteLogErr. pmemlog!main_t.InfiniteLogErr./CRCMismatch)
  TYPE%pmemlog!main_t.InfiniteLogErr.
))
(assert
 (forall ((_head! Int)) (!
   (=>
    (uInv 64 _head!)
    (has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead
       _head!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :pattern ((has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead
       _head!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead_constructor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead_constructor_definition
)))
(assert
 (forall ((x pmemlog!main_t.InfiniteLogErr.)) (!
   (= (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/head x) (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/?head
     x
   ))
   :pattern ((pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/head x))
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/head_accessor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/head_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
    (uInv 64 (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/head (%Poly%pmemlog!main_t.InfiniteLogErr.
       x
   ))))
   :pattern ((pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/head (%Poly%pmemlog!main_t.InfiniteLogErr.
      x
     )
    ) (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
   )
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/head_invariant_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeforeHead/head_invariant_definition
)))
(assert
 (forall ((_tail! Int)) (!
   (=>
    (uInv 64 _tail!)
    (has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail
       _tail!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :pattern ((has_type (Poly%pmemlog!main_t.InfiniteLogErr. (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail
       _tail!
      )
     ) TYPE%pmemlog!main_t.InfiniteLogErr.
   ))
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail_constructor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail_constructor_definition
)))
(assert
 (forall ((x pmemlog!main_t.InfiniteLogErr.)) (!
   (= (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/tail x) (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/?tail
     x
   ))
   :pattern ((pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/tail x))
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/tail_accessor_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/tail_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
    (uInv 64 (pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/tail (%Poly%pmemlog!main_t.InfiniteLogErr.
       x
   ))))
   :pattern ((pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/tail (%Poly%pmemlog!main_t.InfiniteLogErr.
      x
     )
    ) (has_type x TYPE%pmemlog!main_t.InfiniteLogErr.)
   )
   :qid internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/tail_invariant_definition
   :skolemid skolem_internal_pmemlog!main_t.InfiniteLogErr./CantAdvanceHeadPositionBeyondTail/tail_invariant_definition
)))
(assert
 (forall ((x pmemlog!pmemspec_t.PersistentMemoryConstants.)) (!
   (= x (%Poly%pmemlog!pmemspec_t.PersistentMemoryConstants. (Poly%pmemlog!pmemspec_t.PersistentMemoryConstants.
      x
   )))
   :pattern ((Poly%pmemlog!pmemspec_t.PersistentMemoryConstants. x))
   :qid internal_pmemlog__pmemspec_t__PersistentMemoryConstants_box_axiom_definition
   :skolemid skolem_internal_pmemlog__pmemspec_t__PersistentMemoryConstants_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%pmemlog!pmemspec_t.PersistentMemoryConstants.)
    (= x (Poly%pmemlog!pmemspec_t.PersistentMemoryConstants. (%Poly%pmemlog!pmemspec_t.PersistentMemoryConstants.
       x
   ))))
   :pattern ((has_type x TYPE%pmemlog!pmemspec_t.PersistentMemoryConstants.))
   :qid internal_pmemlog__pmemspec_t__PersistentMemoryConstants_unbox_axiom_definition
   :skolemid skolem_internal_pmemlog__pmemspec_t__PersistentMemoryConstants_unbox_axiom_definition
)))
(assert
 (forall ((x pmemlog!pmemspec_t.PersistentMemoryConstants.)) (!
   (= (pmemlog!pmemspec_t.PersistentMemoryConstants./PersistentMemoryConstants/impervious_to_corruption
     x
    ) (pmemlog!pmemspec_t.PersistentMemoryConstants./PersistentMemoryConstants/?impervious_to_corruption
     x
   ))
   :pattern ((pmemlog!pmemspec_t.PersistentMemoryConstants./PersistentMemoryConstants/impervious_to_corruption
     x
   ))
   :qid internal_pmemlog!pmemspec_t.PersistentMemoryConstants./PersistentMemoryConstants/impervious_to_corruption_accessor_definition
   :skolemid skolem_internal_pmemlog!pmemspec_t.PersistentMemoryConstants./PersistentMemoryConstants/impervious_to_corruption_accessor_definition
)))
(assert
 (forall ((x pmemlog!pmemspec_t.PersistentMemoryConstants.)) (!
   (has_type (Poly%pmemlog!pmemspec_t.PersistentMemoryConstants. x) TYPE%pmemlog!pmemspec_t.PersistentMemoryConstants.)
   :pattern ((has_type (Poly%pmemlog!pmemspec_t.PersistentMemoryConstants. x) TYPE%pmemlog!pmemspec_t.PersistentMemoryConstants.))
   :qid internal_pmemlog__pmemspec_t__PersistentMemoryConstants_has_type_always_definition
   :skolemid skolem_internal_pmemlog__pmemspec_t__PersistentMemoryConstants_has_type_always_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (= x (%Poly%tuple%0. (Poly%tuple%0. x)))
   :pattern ((Poly%tuple%0. x))
   :qid internal_crate__tuple__0_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%tuple%0.)
    (= x (Poly%tuple%0. (%Poly%tuple%0. x)))
   )
   :pattern ((has_type x TYPE%tuple%0.))
   :qid internal_crate__tuple__0_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_unbox_axiom_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (has_type (Poly%tuple%0. x) TYPE%tuple%0.)
   :pattern ((has_type (Poly%tuple%0. x) TYPE%tuple%0.))
   :qid internal_crate__tuple__0_has_type_always_definition
   :skolemid skolem_internal_crate__tuple__0_has_type_always_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= x (%Poly%tuple%2. (Poly%tuple%2. x)))
   :pattern ((Poly%tuple%2. x))
   :qid internal_crate__tuple__2_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%tuple%2. (%Poly%tuple%2. x)))
   )
   :pattern ((has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__tuple__2_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (_0! Poly) (_1! Poly)) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
    )
    (has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&. T%0& T%1&.
      T%1&
   )))
   :pattern ((has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&.
      T%0& T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2_constructor_definition
   :skolemid skolem_internal_tuple__2./tuple__2_constructor_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/0 x) (tuple%2./tuple%2/?0 x))
   :pattern ((tuple%2./tuple%2/0 x))
   :qid internal_tuple__2./tuple__2/0_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) T%0&)
   )
   :pattern ((tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/0_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/1 x) (tuple%2./tuple%2/?1 x))
   :pattern ((tuple%2./tuple%2/1 x))
   :qid internal_tuple__2./tuple__2/1_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) T%1&)
   )
   :pattern ((tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/1_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/0 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/0 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/0
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/0
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/1 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/1 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/1
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/1
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (ext_eq deep T%0& (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (tuple%2./tuple%2/0 (%Poly%tuple%2.
        y
     )))
     (ext_eq deep T%1& (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (tuple%2./tuple%2/1 (%Poly%tuple%2.
        y
    ))))
    (ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_tuple__2./tuple__2_ext_equal_definition
   :skolemid skolem_internal_tuple__2./tuple__2_ext_equal_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= x (%Poly%tuple%3. (Poly%tuple%3. x)))
   :pattern ((Poly%tuple%3. x))
   :qid internal_crate__tuple__3_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__3_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (= x (Poly%tuple%3. (%Poly%tuple%3. x)))
   )
   :pattern ((has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&)))
   :qid internal_crate__tuple__3_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__3_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (_0!
    Poly
   ) (_1! Poly) (_2! Poly)
  ) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
     (has_type _2! T%2&)
    )
    (has_type (Poly%tuple%3. (tuple%3./tuple%3 _0! _1! _2!)) (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :pattern ((has_type (Poly%tuple%3. (tuple%3./tuple%3 _0! _1! _2!)) (TYPE%tuple%3. T%0&.
      T%0& T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3_constructor_definition
   :skolemid skolem_internal_tuple__3./tuple__3_constructor_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/0 x) (tuple%3./tuple%3/?0 x))
   :pattern ((tuple%3./tuple%3/0 x))
   :qid internal_tuple__3./tuple__3/0_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/0 (%Poly%tuple%3. x)) T%0&)
   )
   :pattern ((tuple%3./tuple%3/0 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/0_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/0_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/1 x) (tuple%3./tuple%3/?1 x))
   :pattern ((tuple%3./tuple%3/1 x))
   :qid internal_tuple__3./tuple__3/1_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/1 (%Poly%tuple%3. x)) T%1&)
   )
   :pattern ((tuple%3./tuple%3/1 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/1_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/1_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/2 x) (tuple%3./tuple%3/?2 x))
   :pattern ((tuple%3./tuple%3/2 x))
   :qid internal_tuple__3./tuple__3/2_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/2_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/2 (%Poly%tuple%3. x)) T%2&)
   )
   :pattern ((tuple%3./tuple%3/2 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/2_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/2_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/0 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/0 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/0
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/0
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/1 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/1 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/1
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/1
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/2 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/2 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/2
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/2
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (deep
    Bool
   ) (x Poly) (y Poly)
  ) (!
   (=>
    (and
     (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (has_type y (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (ext_eq deep T%0& (tuple%3./tuple%3/0 (%Poly%tuple%3. x)) (tuple%3./tuple%3/0 (%Poly%tuple%3.
        y
     )))
     (ext_eq deep T%1& (tuple%3./tuple%3/1 (%Poly%tuple%3. x)) (tuple%3./tuple%3/1 (%Poly%tuple%3.
        y
     )))
     (ext_eq deep T%2& (tuple%3./tuple%3/2 (%Poly%tuple%3. x)) (tuple%3./tuple%3/2 (%Poly%tuple%3.
        y
    ))))
    (ext_eq deep (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y))
   :qid internal_tuple__3./tuple__3_ext_equal_definition
   :skolemid skolem_internal_tuple__3./tuple__3_ext_equal_definition
)))

;; Trait-Bounds
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!view.View. Self%&. Self%&)
    (sized (proj%%vstd!view.View./V Self%&. Self%&))
   )
   :pattern ((tr_bound%vstd!view.View. Self%&. Self%&))
   :qid internal_vstd__view__View_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__view__View_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%core!alloc.Allocator. Self%&. Self%&))
   :qid internal_core__alloc__Allocator_trait_type_bounds_definition
   :skolemid skolem_internal_core__alloc__Allocator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.option.OptionAdditionalFns. Self%&. Self%& T&. T&)
    (and
     (sized Self%&.)
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.option.OptionAdditionalFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__std_specs__option__OptionAdditionalFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__option__OptionAdditionalFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%pmemlog!pmemspec_t.PersistentMemory. Self%&. Self%&)
    (sized Self%&.)
   )
   :pattern ((tr_bound%pmemlog!pmemspec_t.PersistentMemory. Self%&. Self%&))
   :qid internal_pmemlog__pmemspec_t__PersistentMemory_trait_type_bounds_definition
   :skolemid skolem_internal_pmemlog__pmemspec_t__PersistentMemory_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (AbstractStorage&. Dcr) (AbstractStorage& Type))
  (!
   (=>
    (tr_bound%pmemlog!sccf.CheckPermission. Self%&. Self%& AbstractStorage&. AbstractStorage&)
    (sized AbstractStorage&.)
   )
   :pattern ((tr_bound%pmemlog!sccf.CheckPermission. Self%&. Self%& AbstractStorage&.
     AbstractStorage&
   ))
   :qid internal_pmemlog__sccf__CheckPermission_trait_type_bounds_definition
   :skolemid skolem_internal_pmemlog__sccf__CheckPermission_trait_type_bounds_definition
)))

;; Associated-Type-Impls
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $ (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $ (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $slice (SLICE T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $slice (SLICE T&. T&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (REF A&.) A&) (proj%%vstd!view.View./V A&. A&))
   :pattern ((proj%%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (REF A&.) A&) (proj%vstd!view.View./V A&. A&))
   :pattern ((proj%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)) $)
   :pattern ((proj%%vstd!view.View./V $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)) (TYPE%vstd!seq.Seq.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)) (TYPE%core!option.Option.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%vstd!view.View./V $ TYPE%tuple%0.) $)
)
(assert
 (= (proj%vstd!view.View./V $ TYPE%tuple%0.) TYPE%tuple%0.)
)
(assert
 (= (proj%%vstd!view.View./V $ BOOL) $)
)
(assert
 (= (proj%vstd!view.View./V $ BOOL) BOOL)
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 8)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 64)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%vstd!view.View./V $ USIZE) $)
)
(assert
 (= (proj%vstd!view.View./V $ USIZE) USIZE)
)
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (DST (proj%%vstd!view.View./V
      A1&. A1&
   )))
   :pattern ((proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (TYPE%tuple%2.
     (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&) (proj%%vstd!view.View./V
      A1&. A1&
     ) (proj%vstd!view.View./V A1&. A1&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (= (proj%%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
    (DST (proj%%vstd!view.View./V A2&. A2&))
   )
   :pattern ((proj%%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&.
      A2&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (= (proj%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
    (TYPE%tuple%3. (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&)
     (proj%%vstd!view.View./V A1&. A1&) (proj%vstd!view.View./V A1&. A1&) (proj%%vstd!view.View./V
      A2&. A2&
     ) (proj%vstd!view.View./V A2&. A2&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::subrange
(declare-fun vstd!seq.Seq.subrange.? (Dcr Type Poly Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::empty
(declare-fun vstd!seq.Seq.empty.? (Dcr Type) Poly)

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::add
(declare-fun vstd!seq.Seq.add.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_add
(declare-fun vstd!seq.impl&%0.spec_add.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::set::Set::contains
(declare-fun vstd!set.Set.contains.? (Dcr Type Poly Poly) Bool)

;; Function-Decl vstd::slice::spec_slice_len
(declare-fun vstd!slice.spec_slice_len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::view::View::view
(declare-fun vstd!view.View.view.? (Dcr Type Poly) Poly)
(declare-fun vstd!view.View.view%default%.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::std_specs::vec::spec_vec_len
(declare-fun vstd!std_specs.vec.spec_vec_len.? (Dcr Type Dcr Type Poly) Int)

;; Function-Decl vstd::std_specs::option::OptionAdditionalFns::arrow_0
(declare-fun vstd!std_specs.option.OptionAdditionalFns.arrow_0.? (Dcr Type Dcr Type
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.option.OptionAdditionalFns.arrow_0%default%.? (Dcr Type
  Dcr Type Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::option::spec_unwrap
(declare-fun vstd!std_specs.option.spec_unwrap.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::bytes::spec_u64_to_le_bytes
(declare-fun vstd!bytes.spec_u64_to_le_bytes.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl vstd::bytes::spec_u64_from_le_bytes
(declare-fun vstd!bytes.spec_u64_from_le_bytes.? (Poly) Int)

;; Function-Decl pmemlog::pmemspec_t::PersistentMemory::view
(declare-fun pmemlog!pmemspec_t.PersistentMemory.view.? (Dcr Type Poly) Poly)
(declare-fun pmemlog!pmemspec_t.PersistentMemory.view%default%.? (Dcr Type Poly) Poly)

;; Function-Decl pmemlog::pmemspec_t::PersistentMemory::inv
(declare-fun pmemlog!pmemspec_t.PersistentMemory.inv.? (Dcr Type Poly) Poly)
(declare-fun pmemlog!pmemspec_t.PersistentMemory.inv%default%.? (Dcr Type Poly) Poly)

;; Function-Decl pmemlog::pmemspec_t::PersistentMemory::constants
(declare-fun pmemlog!pmemspec_t.PersistentMemory.constants.? (Dcr Type Poly) Poly)
(declare-fun pmemlog!pmemspec_t.PersistentMemory.constants%default%.? (Dcr Type Poly)
 Poly
)

;; Function-Decl pmemlog::pmemspec_t::maybe_corrupted_byte
(declare-fun pmemlog!pmemspec_t.maybe_corrupted_byte.? (Poly Poly Poly) Bool)

;; Function-Decl pmemlog::pmemspec_t::maybe_corrupted
(declare-fun pmemlog!pmemspec_t.maybe_corrupted.? (Poly Poly Poly) Bool)

;; Function-Decl pmemlog::pmemspec_t::update_byte_to_reflect_write
(declare-fun pmemlog!pmemspec_t.update_byte_to_reflect_write.? (Poly Poly Poly Poly)
 Int
)

;; Function-Decl pmemlog::pmemspec_t::update_contents_to_reflect_write
(declare-fun pmemlog!pmemspec_t.update_contents_to_reflect_write.? (Poly Poly Poly)
 vstd!seq.Seq<u8.>.
)

;; Function-Decl pmemlog::pmemspec_t::spec_crc_bytes
(declare-fun pmemlog!pmemspec_t.spec_crc_bytes.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl pmemlog::pmemspec_t::crc_size
(declare-fun pmemlog!pmemspec_t.crc_size.? () Int)

;; Function-Decl pmemlog::pmemspec_t::all_elements_unique
(declare-fun pmemlog!pmemspec_t.all_elements_unique.? (Poly) Bool)

;; Function-Decl pmemlog::pmemspec_t::cdb0_val
(declare-fun pmemlog!pmemspec_t.cdb0_val.? () Int)

;; Function-Decl pmemlog::pmemspec_t::cdb1_val
(declare-fun pmemlog!pmemspec_t.cdb1_val.? () Int)

;; Function-Decl pmemlog::sccf::CheckPermission::check_permission
(declare-fun pmemlog!sccf.CheckPermission.check_permission.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun pmemlog!sccf.CheckPermission.check_permission%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl pmemlog::infinitelog_t::AbstractInfiniteLogState::initialize
(declare-fun pmemlog!infinitelog_t.impl&%0.initialize.? (Poly) pmemlog!infinitelog_t.AbstractInfiniteLogState.)

;; Function-Decl pmemlog::infinitelog_t::AbstractInfiniteLogState::append
(declare-fun pmemlog!infinitelog_t.impl&%0.append.? (Poly Poly) pmemlog!infinitelog_t.AbstractInfiniteLogState.)

;; Function-Decl pmemlog::infinitelog_t::AbstractInfiniteLogState::advance_head
(declare-fun pmemlog!infinitelog_t.impl&%0.advance_head.? (Poly Poly) pmemlog!infinitelog_t.AbstractInfiniteLogState.)

;; Function-Decl pmemlog::logimpl_v::incorruptible_bool_pos
(declare-fun pmemlog!logimpl_v.incorruptible_bool_pos.? () Int)

;; Function-Decl pmemlog::logimpl_v::header1_pos
(declare-fun pmemlog!logimpl_v.header1_pos.? () Int)

;; Function-Decl pmemlog::logimpl_v::header2_pos
(declare-fun pmemlog!logimpl_v.header2_pos.? () Int)

;; Function-Decl pmemlog::logimpl_v::header_crc_offset
(declare-fun pmemlog!logimpl_v.header_crc_offset.? () Int)

;; Function-Decl pmemlog::logimpl_v::header_head_offset
(declare-fun pmemlog!logimpl_v.header_head_offset.? () Int)

;; Function-Decl pmemlog::logimpl_v::header_tail_offset
(declare-fun pmemlog!logimpl_v.header_tail_offset.? () Int)

;; Function-Decl pmemlog::logimpl_v::header_log_size_offset
(declare-fun pmemlog!logimpl_v.header_log_size_offset.? () Int)

;; Function-Decl pmemlog::logimpl_v::header_size
(declare-fun pmemlog!logimpl_v.header_size.? () Int)

;; Function-Decl pmemlog::logimpl_v::spec_bytes_to_metadata
(declare-fun pmemlog!logimpl_v.spec_bytes_to_metadata.? (Poly) pmemlog!logimpl_v.PersistentHeaderMetadata.)

;; Function-Decl pmemlog::logimpl_v::contents_offset
(declare-fun pmemlog!logimpl_v.contents_offset.? () Int)

;; Function-Decl pmemlog::logimpl_v::pm_to_views
(declare-fun pmemlog!logimpl_v.pm_to_views.? (Poly) tuple%3.)

;; Function-Decl pmemlog::logimpl_v::spec_get_live_header
(declare-fun pmemlog!logimpl_v.spec_get_live_header.? (Poly) pmemlog!logimpl_v.PersistentHeader.)

;; Function-Decl pmemlog::logimpl_v::UntrustedLogImpl::log_state_is_valid
(declare-fun pmemlog!logimpl_v.impl&%0.log_state_is_valid.? (Poly) Bool)

;; Function-Decl pmemlog::logimpl_v::spec_addr_logical_to_physical
(declare-fun pmemlog!logimpl_v.spec_addr_logical_to_physical.? (Poly Poly) Int)

;; Function-Decl pmemlog::logimpl_v::UntrustedLogImpl::recover
(declare-fun pmemlog!logimpl_v.impl&%0.recover.? (Poly) core!option.Option.)

;; Function-Decl pmemlog::main_t::recovery_view
(declare-fun pmemlog!main_t.recovery_view.? (Poly) %%Function%%)

;; Function-Decl pmemlog::logimpl_v::permissions_depend_only_on_recovery_view
(declare-fun pmemlog!logimpl_v.permissions_depend_only_on_recovery_view.? (Dcr Type
  Poly
 ) Bool
)

;; Function-Decl pmemlog::logimpl_v::spec_bytes_to_header
(declare-fun pmemlog!logimpl_v.spec_bytes_to_header.? (Poly) pmemlog!logimpl_v.PersistentHeader.)

;; Function-Decl pmemlog::logimpl_v::update_data_view_postcond
(declare-fun pmemlog!logimpl_v.update_data_view_postcond.? (Poly Poly Poly) Bool)

;; Function-Decl pmemlog::logimpl_v::live_data_view_eq
(declare-fun pmemlog!logimpl_v.live_data_view_eq.? (Poly Poly) Bool)

;; Function-Decl pmemlog::logimpl_v::UntrustedLogImpl::inv_pm_contents
(declare-fun pmemlog!logimpl_v.impl&%0.inv_pm_contents.? (Poly Poly) Bool)

;; Function-Decl pmemlog::pmemspec_t::WriteRestrictedPersistentMemory::inv
(declare-fun pmemlog!pmemspec_t.impl&%0.inv.? (Dcr Type Dcr Type Poly) Bool)

;; Function-Decl pmemlog::pmemspec_t::WriteRestrictedPersistentMemory::view
(declare-fun pmemlog!pmemspec_t.impl&%0.view.? (Dcr Type Dcr Type Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl pmemlog::logimpl_v::UntrustedLogImpl::inv
(declare-fun pmemlog!logimpl_v.impl&%0.inv.? (Dcr Type Dcr Type Poly Poly) Bool)

;; Function-Decl pmemlog::main_t::read_correct_modulo_corruption
(declare-fun pmemlog!main_t.read_correct_modulo_corruption.? (Poly Poly Poly) Bool)

;; Function-Decl pmemlog::pmemspec_t::WriteRestrictedPersistentMemory::constants
(declare-fun pmemlog!pmemspec_t.impl&%0.constants.? (Dcr Type Dcr Type Poly) pmemlog!pmemspec_t.PersistentMemoryConstants.)

;; Function-Decl pmemlog::pmemspec_t::persistence_chunk_size
(declare-fun pmemlog!pmemspec_t.persistence_chunk_size.? () Int)

;; Function-Decl pmemlog::pmemspec_t::update_byte_to_reflect_partially_flushed_write
(declare-fun pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.? (
  Poly Poly Poly Poly Poly
 ) Int
)

;; Function-Decl pmemlog::pmemspec_t::update_contents_to_reflect_partially_flushed_write
(declare-fun pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.?
 (Poly Poly Poly Poly) vstd!seq.Seq<u8.>.
)

;; Function-Axioms vstd::seq::Seq::len
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
    (<= 0 (vstd!seq.Seq.len.? A&. A& self!))
   )
   :pattern ((vstd!seq.Seq.len.? A&. A& self!))
   :qid internal_vstd!seq.Seq.len.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.len.?_pre_post_definition
)))

;; Function-Specs vstd::seq::Seq::index
(declare-fun req%vstd!seq.Seq.index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%0 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.Seq.index. A&. A& self! i!) (=>
     %%global_location_label%%0
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.Seq.index. A&. A& self! i!))
   :qid internal_req__vstd!seq.Seq.index._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.index._definition
)))

;; Function-Axioms vstd::seq::Seq::index
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.Seq.index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.Seq.index.? A&. A& self! i!))
   :qid internal_vstd!seq.Seq.index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.index.?_pre_post_definition
)))

;; Function-Specs vstd::seq::impl&%0::spec_index
(declare-fun req%vstd!seq.impl&%0.spec_index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%1 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.impl&%0.spec_index. A&. A& self! i!) (=>
     %%global_location_label%%1
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.impl&%0.spec_index. A&. A& self! i!))
   :qid internal_req__vstd!seq.impl&__0.spec_index._definition
   :skolemid skolem_internal_req__vstd!seq.impl&__0.spec_index._definition
)))

;; Function-Axioms vstd::seq::impl&%0::spec_index
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.spec_index.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
    (= (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) (vstd!seq.Seq.index.? A&. A& self!
      i!
    ))
    :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
    :qid internal_vstd!seq.impl&__0.spec_index.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
   :qid internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_index_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_index_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
      )))
      (height_lt (height (vstd!seq.Seq.index.? A&. A& s! i!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.index.? A&. A& s! i!)))
    :qid user_vstd__seq__axiom_seq_index_decreases_0
    :skolemid skolem_user_vstd__seq__axiom_seq_index_decreases_0
))))

;; Function-Specs vstd::seq::Seq::subrange
(declare-fun req%vstd!seq.Seq.subrange. (Dcr Type Poly Poly Poly) Bool)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (start_inclusive! Poly) (end_exclusive! Poly))
  (!
   (= (req%vstd!seq.Seq.subrange. A&. A& self! start_inclusive! end_exclusive!) (=>
     %%global_location_label%%2
     (let
      ((tmp%%$ (%I start_inclusive!)))
      (let
       ((tmp%%$1 (%I end_exclusive!)))
       (and
        (and
         (<= 0 tmp%%$)
         (<= tmp%%$ tmp%%$1)
        )
        (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& self!))
   )))))
   :pattern ((req%vstd!seq.Seq.subrange. A&. A& self! start_inclusive! end_exclusive!))
   :qid internal_req__vstd!seq.Seq.subrange._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.subrange._definition
)))

;; Function-Axioms vstd::seq::Seq::subrange
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (start_inclusive! Poly) (end_exclusive! Poly))
  (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type start_inclusive! INT)
     (has_type end_exclusive! INT)
    )
    (has_type (vstd!seq.Seq.subrange.? A&. A& self! start_inclusive! end_exclusive!) (
      TYPE%vstd!seq.Seq. A&. A&
   )))
   :pattern ((vstd!seq.Seq.subrange.? A&. A& self! start_inclusive! end_exclusive!))
   :qid internal_vstd!seq.Seq.subrange.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.subrange.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_subrange_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly) (j! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
      (has_type j! INT)
     )
     (=>
      (and
       (and
        (sized A&.)
        (let
         ((tmp%%$ (%I i!)))
         (let
          ((tmp%%$1 (%I j!)))
          (and
           (and
            (<= 0 tmp%%$)
            (<= tmp%%$ tmp%%$1)
           )
           (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
       ))))
       (< (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! i! j!)) (vstd!seq.Seq.len.?
         A&. A& s!
      )))
      (height_lt (height (vstd!seq.Seq.subrange.? A&. A& s! i! j!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.subrange.? A&. A& s! i! j!)))
    :qid user_vstd__seq__axiom_seq_subrange_decreases_1
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_decreases_1
))))

;; Function-Axioms vstd::seq::Seq::empty
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (has_type (vstd!seq.Seq.empty.? A&. A&) (TYPE%vstd!seq.Seq. A&. A&))
   :pattern ((vstd!seq.Seq.empty.? A&. A&))
   :qid internal_vstd!seq.Seq.empty.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.empty.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_empty
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_empty.)
  (forall ((A&. Dcr) (A& Type)) (!
    (=>
     (sized A&.)
     (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.empty.? A&. A&)) 0)
    )
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.empty.? A&. A&)))
    :qid user_vstd__seq__axiom_seq_empty_2
    :skolemid skolem_user_vstd__seq__axiom_seq_empty_2
))))

;; Function-Axioms vstd::seq::Seq::new
(assert
 (forall ((A&. Dcr) (A& Type) (impl%1&. Dcr) (impl%1& Type) (len! Poly) (f! Poly))
  (!
   (=>
    (and
     (has_type len! NAT)
     (has_type f! impl%1&)
    )
    (has_type (vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!) (TYPE%vstd!seq.Seq.
      A&. A&
   )))
   :pattern ((vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!))
   :qid internal_vstd!seq.Seq.new.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.new.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_new_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_len.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
     )
     (=>
      (sized A&.)
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        )
       ) (%I len!)
    )))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
    )))
    :qid user_vstd__seq__axiom_seq_new_len_3
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_3
))))

;; Broadcast vstd::seq::axiom_seq_new_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_index.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (%I len!))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        ) i!
       ) (%%apply%%0 (%Poly%fun%1. f!) i!)
    )))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
      ) i!
    ))
    :qid user_vstd__seq__axiom_seq_new_index_4
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_4
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (= (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2! i$))
          ))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_5
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_5
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_6
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_6
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal_deep
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal_deep.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (ext_eq true A& (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2!
              i$
          ))))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_7
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_7
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_8
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_8
))))

;; Broadcast vstd::seq::axiom_seq_subrange_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_len.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I j!)))
        (let
         ((tmp%%$1 (%I k!)))
         (and
          (and
           (<= 0 tmp%%$)
           (<= tmp%%$ tmp%%$1)
          )
          (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
      ))))
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!)) (Sub (%I k!)
        (%I j!)
    ))))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!)))
    :qid user_vstd__seq__axiom_seq_subrange_len_9
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_len_9
))))

;; Broadcast vstd::seq::axiom_seq_subrange_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_index.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k! INT)
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (sized A&.)
        (let
         ((tmp%%$ (%I j!)))
         (let
          ((tmp%%$1 (%I k!)))
          (and
           (and
            (<= 0 tmp%%$)
            (<= tmp%%$ tmp%%$1)
           )
           (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
       ))))
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (Sub (%I k!) (%I j!)))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!) i!) (vstd!seq.Seq.index.?
        A&. A& s! (I (Add (%I i!) (%I j!)))
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!) i!))
    :qid user_vstd__seq__axiom_seq_subrange_index_10
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_index_10
))))

;; Broadcast vstd::seq::lemma_seq_two_subranges_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.lemma_seq_two_subranges_index.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k1! Poly) (k2! Poly) (i! Poly))
   (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k1! INT)
      (has_type k2! INT)
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (and
         (and
          (sized A&.)
          (let
           ((tmp%%$ (%I j!)))
           (let
            ((tmp%%$1 (%I k1!)))
            (and
             (and
              (<= 0 tmp%%$)
              (<= tmp%%$ tmp%%$1)
             )
             (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
         ))))
         (let
          ((tmp%%$ (%I j!)))
          (let
           ((tmp%%$3 (%I k2!)))
           (and
            (and
             (<= 0 tmp%%$)
             (<= tmp%%$ tmp%%$3)
            )
            (<= tmp%%$3 (vstd!seq.Seq.len.? A&. A& s!))
        ))))
        (let
         ((tmp%%$ (%I i!)))
         (and
          (<= 0 tmp%%$)
          (< tmp%%$ (Sub (%I k1!) (%I j!)))
       )))
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (Sub (%I k2!) (%I j!)))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k1!) i!) (vstd!seq.Seq.index.?
        A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k2!) i!
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k1!) i!)
     (vstd!seq.Seq.subrange.? A&. A& s! j! k2!)
    )
    :qid user_vstd__seq__lemma_seq_two_subranges_index_11
    :skolemid skolem_user_vstd__seq__lemma_seq_two_subranges_index_11
))))

;; Function-Axioms vstd::seq::Seq::add
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (rhs! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type rhs! (TYPE%vstd!seq.Seq. A&. A&))
    )
    (has_type (vstd!seq.Seq.add.? A&. A& self! rhs!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.Seq.add.? A&. A& self! rhs!))
   :qid internal_vstd!seq.Seq.add.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.add.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_add_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_add_len.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.add.? A&. A& s1! s2!)) (nClip (Add (vstd!seq.Seq.len.?
          A&. A& s1!
         ) (vstd!seq.Seq.len.? A&. A& s2!)
    )))))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.add.? A&. A& s1! s2!)))
    :qid user_vstd__seq__axiom_seq_add_len_12
    :skolemid skolem_user_vstd__seq__axiom_seq_add_len_12
))))

;; Broadcast vstd::seq::axiom_seq_add_index1
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_add_index1.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.add.? A&. A& s1! s2!) i!) (vstd!seq.Seq.index.?
        A&. A& s1! i!
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.add.? A&. A& s1! s2!) i!))
    :qid user_vstd__seq__axiom_seq_add_index1_13
    :skolemid skolem_user_vstd__seq__axiom_seq_add_index1_13
))))

;; Broadcast vstd::seq::axiom_seq_add_index2
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_add_index2.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= (vstd!seq.Seq.len.? A&. A& s1!) tmp%%$)
         (< tmp%%$ (nClip (Add (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.add.? A&. A& s1! s2!) i!) (vstd!seq.Seq.index.?
        A&. A& s2! (I (Sub (%I i!) (vstd!seq.Seq.len.? A&. A& s1!)))
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.add.? A&. A& s1! s2!) i!))
    :qid user_vstd__seq__axiom_seq_add_index2_14
    :skolemid skolem_user_vstd__seq__axiom_seq_add_index2_14
))))

;; Function-Axioms vstd::seq::impl&%0::spec_add
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.spec_add.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.spec_add.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (rhs! Poly)) (!
    (= (vstd!seq.impl&%0.spec_add.? A&. A& self! rhs!) (vstd!seq.Seq.add.? A&. A& self!
      rhs!
    ))
    :pattern ((vstd!seq.impl&%0.spec_add.? A&. A& self! rhs!))
    :qid internal_vstd!seq.impl&__0.spec_add.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.spec_add.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (rhs! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type rhs! (TYPE%vstd!seq.Seq. A&. A&))
    )
    (has_type (vstd!seq.impl&%0.spec_add.? A&. A& self! rhs!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.impl&%0.spec_add.? A&. A& self! rhs!))
   :qid internal_vstd!seq.impl&__0.spec_add.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.spec_add.?_pre_post_definition
)))

;; Broadcast vstd::seq_lib::impl&%0::add_empty_left
(assert
 (=>
  (fuel_bool fuel%vstd!seq_lib.impl&%0.add_empty_left.)
  (forall ((A&. Dcr) (A& Type) (a! Poly) (b! Poly)) (!
    (=>
     (and
      (has_type a! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type b! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (and
       (sized A&.)
       (= (vstd!seq.Seq.len.? A&. A& a!) 0)
      )
      (= (vstd!seq.Seq.add.? A&. A& a! b!) b!)
    ))
    :pattern ((vstd!seq.Seq.add.? A&. A& a! b!))
    :qid user_vstd__seq_lib__impl&%0__add_empty_left_15
    :skolemid skolem_user_vstd__seq_lib__impl&%0__add_empty_left_15
))))

;; Broadcast vstd::seq_lib::impl&%0::add_empty_right
(assert
 (=>
  (fuel_bool fuel%vstd!seq_lib.impl&%0.add_empty_right.)
  (forall ((A&. Dcr) (A& Type) (a! Poly) (b! Poly)) (!
    (=>
     (and
      (has_type a! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type b! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (and
       (sized A&.)
       (= (vstd!seq.Seq.len.? A&. A& b!) 0)
      )
      (= (vstd!seq.Seq.add.? A&. A& a! b!) a!)
    ))
    :pattern ((vstd!seq.Seq.add.? A&. A& a! b!))
    :qid user_vstd__seq_lib__impl&%0__add_empty_right_16
    :skolemid skolem_user_vstd__seq_lib__impl&%0__add_empty_right_16
))))

;; Broadcast vstd::set::axiom_set_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!set.axiom_set_ext_equal.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!set.Set. A&. A&))
      (has_type s2! (TYPE%vstd!set.Set. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq false (TYPE%vstd!set.Set. A&. A&) s1! s2!) (forall ((a$ Poly)) (!
         (=>
          (has_type a$ A&)
          (= (vstd!set.Set.contains.? A&. A& s1! a$) (vstd!set.Set.contains.? A&. A& s2! a$))
         )
         :pattern ((vstd!set.Set.contains.? A&. A& s1! a$))
         :pattern ((vstd!set.Set.contains.? A&. A& s2! a$))
         :qid user_vstd__set__axiom_set_ext_equal_17
         :skolemid skolem_user_vstd__set__axiom_set_ext_equal_17
    )))))
    :pattern ((ext_eq false (TYPE%vstd!set.Set. A&. A&) s1! s2!))
    :qid user_vstd__set__axiom_set_ext_equal_18
    :skolemid skolem_user_vstd__set__axiom_set_ext_equal_18
))))

;; Broadcast vstd::set::axiom_set_ext_equal_deep
(assert
 (=>
  (fuel_bool fuel%vstd!set.axiom_set_ext_equal_deep.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!set.Set. A&. A&))
      (has_type s2! (TYPE%vstd!set.Set. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq true (TYPE%vstd!set.Set. A&. A&) s1! s2!) (ext_eq false (TYPE%vstd!set.Set.
         A&. A&
        ) s1! s2!
    ))))
    :pattern ((ext_eq true (TYPE%vstd!set.Set. A&. A&) s1! s2!))
    :qid user_vstd__set__axiom_set_ext_equal_deep_19
    :skolemid skolem_user_vstd__set__axiom_set_ext_equal_deep_19
))))

;; Function-Axioms vstd::slice::spec_slice_len
(assert
 (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
   (=>
    (has_type slice! (SLICE T&. T&))
    (uInv SZ (vstd!slice.spec_slice_len.? T&. T& slice!))
   )
   :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
   :qid internal_vstd!slice.spec_slice_len.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.spec_slice_len.?_pre_post_definition
)))

;; Function-Axioms vstd::view::View::view
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!view.View.view.? Self%&. Self%& self!) (proj%vstd!view.View./V Self%&.
      Self%&
   )))
   :pattern ((vstd!view.View.view.? Self%&. Self%& self!))
   :qid internal_vstd!view.View.view.?_pre_post_definition
   :skolemid skolem_internal_vstd!view.View.view.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!view.View. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%vstd!view.View. $slice (SLICE T&. T&)))
   :qid internal_vstd__slice__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_spec_len
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_spec_len.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
    (=>
     (has_type slice! (SLICE T&. T&))
     (=>
      (sized T&.)
      (= (vstd!slice.spec_slice_len.? T&. T& slice!) (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.?
         $slice (SLICE T&. T&) slice!
    )))))
    :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
    :qid user_vstd__slice__axiom_spec_len_20
    :skolemid skolem_user_vstd__slice__axiom_spec_len_20
))))

;; Function-Specs vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun req%vstd!slice.SliceAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%3
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::slice::SliceAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::slice::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!slice.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!slice.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!)
       i!
    )))
    :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&.
      T& self! i!
    ))
    :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&)
   )
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&))
   :qid internal_vstd__slice__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_slice_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (SLICE T&. T&))
      (has_type a2! (SLICE T&. T&))
     )
     (=>
      (sized T&.)
      (= (ext_eq false (SLICE T&. T&) a1! a2!) (and
        (= (vstd!slice.spec_slice_len.? T&. T& a1!) (vstd!slice.spec_slice_len.? T&. T& a2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& a1!))
            ))
            (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a1!) i$)
             (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a2!) i$)
          )))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a1!
            ) i$
          ))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a2!
            ) i$
          ))
          :qid user_vstd__slice__axiom_slice_ext_equal_21
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_21
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_22
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_22
))))

;; Broadcast vstd::slice::axiom_slice_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type slice! (SLICE T&. T&))
      (has_type i! INT)
     )
     (=>
      (sized T&.)
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& slice!))
       ))
       (=>
        (has_resolved $slice (SLICE T&. T&) slice!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE
            T&. T&
           ) slice!
          ) i!
    ))))))
    :pattern ((has_resolved $slice (SLICE T&. T&) slice!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $slice (SLICE T&. T&) slice!) i!
    ))
    :qid user_vstd__slice__axiom_slice_has_resolved_23
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_23
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq
(assert
 (forall ((T&. Dcr) (T& Type) (data! Poly)) (!
   (=>
    (has_type data! (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!) (PTR T&. T&))
   )
   :pattern ((vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. $ (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. $ (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (= (vstd!raw_ptr.view_reverse_for_eq.? T&. T& (vstd!view.View.view.? $ (PTR T&. T&)
        a!
       )
      ) a!
    ))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_24
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_24
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq_sized
(assert
 (forall ((T&. Dcr) (T& Type) (addr! Poly) (provenance! Poly)) (!
   (=>
    (and
     (has_type addr! USIZE)
     (has_type provenance! TYPE%vstd!raw_ptr.Provenance.)
    )
    (has_type (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!) (PTR
      T&. T&
   )))
   :pattern ((vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq_sized
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (=>
      (sized T&.)
      (= (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& (I (vstd!raw_ptr.PtrData./PtrData/addr
          (%Poly%vstd!raw_ptr.PtrData. (vstd!view.View.view.? $ (PTR T&. T&) a!))
         )
        ) (Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.PtrData./PtrData/provenance (%Poly%vstd!raw_ptr.PtrData.
           (vstd!view.View.view.? $ (PTR T&. T&) a!)
        )))
       ) a!
    )))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_25
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_25
))))

;; Function-Axioms vstd::std_specs::vec::spec_vec_len
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (v! Poly)) (!
   (=>
    (has_type v! (TYPE%alloc!vec.Vec. T&. T& A&. A&))
    (uInv SZ (vstd!std_specs.vec.spec_vec_len.? T&. T& A&. A& v!))
   )
   :pattern ((vstd!std_specs.vec.spec_vec_len.? T&. T& A&. A& v!))
   :qid internal_vstd!std_specs.vec.spec_vec_len.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.vec.spec_vec_len.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A&.)
     (tr_bound%core!alloc.Allocator. A&. A&)
    )
    (tr_bound%vstd!view.View. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)))
   :qid internal_vstd__view__impl&__8_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__8_trait_impl_definition
)))

;; Broadcast vstd::std_specs::vec::axiom_spec_len
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.vec.axiom_spec_len.)
  (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (v! Poly)) (!
    (=>
     (has_type v! (TYPE%alloc!vec.Vec. T&. T& A&. A&))
     (=>
      (and
       (and
        (sized T&.)
        (sized A&.)
       )
       (tr_bound%core!alloc.Allocator. A&. A&)
      )
      (= (vstd!std_specs.vec.spec_vec_len.? T&. T& A&. A& v!) (vstd!seq.Seq.len.? T&. T&
        (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) v!)
    ))))
    :pattern ((vstd!std_specs.vec.spec_vec_len.? T&. T& A&. A& v!))
    :qid user_vstd__std_specs__vec__axiom_spec_len_26
    :skolemid skolem_user_vstd__std_specs__vec__axiom_spec_len_26
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!alloc.Allocator. $ ALLOCATOR_GLOBAL)
)

;; Broadcast vstd::std_specs::vec::axiom_vec_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.vec.axiom_vec_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (vec! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type vec! (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL))
      (has_type i! INT)
     )
     (=>
      (sized T&.)
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!std_specs.vec.spec_vec_len.? T&. T& $ ALLOCATOR_GLOBAL vec!))
       ))
       (=>
        (has_resolved $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) vec!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
            T&. T& $ ALLOCATOR_GLOBAL
           ) vec!
          ) i!
    ))))))
    :pattern ((has_resolved $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) vec!) (vstd!seq.Seq.index.?
      T&. T& (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) vec!)
      i!
    ))
    :qid user_vstd__std_specs__vec__axiom_vec_has_resolved_27
    :skolemid skolem_user_vstd__std_specs__vec__axiom_vec_has_resolved_27
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_division_less_than_divisor
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. (Int
  Int
 ) Bool
)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!) (=>
     %%global_location_label%%4
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. (Int
  Int
 ) Bool
)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!) (let
     ((tmp%%$ (EucMod x! m!)))
     (and
      (<= 0 tmp%%$)
      (< tmp%%$ m!)
   )))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_division_less_than_divisor
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (> m! 0)
     (let
      ((tmp%%$ (EucMod x! m!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ m!)
    )))
    :pattern ((EucMod x! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_division_less_than_divisor_28
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_division_less_than_divisor_28
))))

;; Function-Axioms vstd::std_specs::option::OptionAdditionalFns::arrow_0
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!std_specs.option.OptionAdditionalFns.arrow_0.? Self%&. Self%& T&. T&
      self!
     ) T&
   ))
   :pattern ((vstd!std_specs.option.OptionAdditionalFns.arrow_0.? Self%&. Self%& T&. T&
     self!
   ))
   :qid internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::option::impl&%0::arrow_0
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.impl&%0.arrow_0.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.impl&%0.arrow_0.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.option.OptionAdditionalFns.arrow_0.? $ (TYPE%core!option.Option.
        T&. T&
       ) T&. T& self!
      ) (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. self!))
    ))
    :pattern ((vstd!std_specs.option.OptionAdditionalFns.arrow_0.? $ (TYPE%core!option.Option.
       T&. T&
      ) T&. T& self!
    ))
    :qid internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!std_specs.option.OptionAdditionalFns. $ (TYPE%core!option.Option. T&.
      T&
     ) T&. T&
   ))
   :pattern ((tr_bound%vstd!std_specs.option.OptionAdditionalFns. $ (TYPE%core!option.Option.
      T&. T&
     ) T&. T&
   ))
   :qid internal_vstd__std_specs__option__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__option__impl&__0_trait_impl_definition
)))

;; Function-Specs vstd::std_specs::option::spec_unwrap
(declare-fun req%vstd!std_specs.option.spec_unwrap. (Dcr Type Poly) Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
   (= (req%vstd!std_specs.option.spec_unwrap. T&. T& option!) (=>
     %%global_location_label%%5
     (is-core!option.Option./Some (%Poly%core!option.Option. option!))
   ))
   :pattern ((req%vstd!std_specs.option.spec_unwrap. T&. T& option!))
   :qid internal_req__vstd!std_specs.option.spec_unwrap._definition
   :skolemid skolem_internal_req__vstd!std_specs.option.spec_unwrap._definition
)))

;; Function-Axioms vstd::std_specs::option::spec_unwrap
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.spec_unwrap.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.spec_unwrap.)
  (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
    (= (vstd!std_specs.option.spec_unwrap.? T&. T& option!) (core!option.Option./Some/0
      T&. T& (%Poly%core!option.Option. option!)
    ))
    :pattern ((vstd!std_specs.option.spec_unwrap.? T&. T& option!))
    :qid internal_vstd!std_specs.option.spec_unwrap.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
   (=>
    (has_type option! (TYPE%core!option.Option. T&. T&))
    (has_type (vstd!std_specs.option.spec_unwrap.? T&. T& option!) T&)
   )
   :pattern ((vstd!std_specs.option.spec_unwrap.? T&. T& option!))
   :qid internal_vstd!std_specs.option.spec_unwrap.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap.?_pre_post_definition
)))

;; Function-Specs alloc::vec::impl&%1::len
(declare-fun ens%alloc!vec.impl&%1.len. (Dcr Type Dcr Type Poly Int) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (vec! Poly) (len! Int)) (!
   (= (ens%alloc!vec.impl&%1.len. T&. T& A&. A& vec! len!) (and
     (uInv SZ len!)
     (= len! (vstd!std_specs.vec.spec_vec_len.? T&. T& A&. A& vec!))
   ))
   :pattern ((ens%alloc!vec.impl&%1.len. T&. T& A&. A& vec! len!))
   :qid internal_ens__alloc!vec.impl&__1.len._definition
   :skolemid skolem_internal_ens__alloc!vec.impl&__1.len._definition
)))

;; Function-Specs alloc::vec::impl&%0::new
(declare-fun ens%alloc!vec.impl&%0.new. (Dcr Type Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (v! Poly)) (!
   (= (ens%alloc!vec.impl&%0.new. T&. T& v!) (and
     (has_type v! (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL))
     (= (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) v!) (vstd!seq.Seq.empty.?
       T&. T&
   ))))
   :pattern ((ens%alloc!vec.impl&%0.new. T&. T& v!))
   :qid internal_ens__alloc!vec.impl&__0.new._definition
   :skolemid skolem_internal_ens__alloc!vec.impl&__0.new._definition
)))

;; Function-Specs alloc::vec::impl&%1::append
(declare-fun ens%alloc!vec.impl&%1.append. (Dcr Type Dcr Type Poly Poly Poly Poly)
 Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (pre%vec! Poly) (vec! Poly) (pre%other!
    Poly
   ) (other! Poly)
  ) (!
   (= (ens%alloc!vec.impl&%1.append. T&. T& A&. A& pre%vec! vec! pre%other! other!) (
     and
     (has_type vec! (TYPE%alloc!vec.Vec. T&. T& A&. A&))
     (has_type other! (TYPE%alloc!vec.Vec. T&. T& A&. A&))
     (= (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) vec!) (vstd!seq.Seq.add.?
       T&. T& (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) pre%vec!) (vstd!view.View.view.?
        $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) pre%other!
     )))
     (= (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) other!) (vstd!seq.Seq.empty.?
       T&. T&
   ))))
   :pattern ((ens%alloc!vec.impl&%1.append. T&. T& A&. A& pre%vec! vec! pre%other! other!))
   :qid internal_ens__alloc!vec.impl&__1.append._definition
   :skolemid skolem_internal_ens__alloc!vec.impl&__1.append._definition
)))

;; Function-Specs alloc::vec::impl&%1::as_slice
(declare-fun ens%alloc!vec.impl&%1.as_slice. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (vec! Poly) (slice! Poly)) (!
   (= (ens%alloc!vec.impl&%1.as_slice. T&. T& A&. A& vec! slice!) (and
     (has_type slice! (SLICE T&. T&))
     (= (vstd!view.View.view.? $slice (SLICE T&. T&) slice!) (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
        T&. T& A&. A&
       ) vec!
   ))))
   :pattern ((ens%alloc!vec.impl&%1.as_slice. T&. T& A&. A& vec! slice!))
   :qid internal_ens__alloc!vec.impl&__1.as_slice._definition
   :skolemid skolem_internal_ens__alloc!vec.impl&__1.as_slice._definition
)))

;; Function-Specs vstd::bytes::spec_u64_from_le_bytes
(declare-fun req%vstd!bytes.spec_u64_from_le_bytes. (Poly) Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((s! Poly)) (!
   (= (req%vstd!bytes.spec_u64_from_le_bytes. s!) (=>
     %%global_location_label%%6
     (= (vstd!seq.Seq.len.? $ (UINT 8) s!) 8)
   ))
   :pattern ((req%vstd!bytes.spec_u64_from_le_bytes. s!))
   :qid internal_req__vstd!bytes.spec_u64_from_le_bytes._definition
   :skolemid skolem_internal_req__vstd!bytes.spec_u64_from_le_bytes._definition
)))

;; Function-Axioms vstd::bytes::spec_u64_from_le_bytes
(assert
 (forall ((s! Poly)) (!
   (=>
    (has_type s! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (uInv 64 (vstd!bytes.spec_u64_from_le_bytes.? s!))
   )
   :pattern ((vstd!bytes.spec_u64_from_le_bytes.? s!))
   :qid internal_vstd!bytes.spec_u64_from_le_bytes.?_pre_post_definition
   :skolemid skolem_internal_vstd!bytes.spec_u64_from_le_bytes.?_pre_post_definition
)))

;; Function-Specs vstd::bytes::lemma_auto_spec_u64_to_from_le_bytes
(declare-fun ens%vstd!bytes.lemma_auto_spec_u64_to_from_le_bytes. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%vstd!bytes.lemma_auto_spec_u64_to_from_le_bytes. no%param) (and
     (forall ((x$ Poly)) (!
       (=>
        (has_type x$ (UINT 64))
        (and
         (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. (vstd!bytes.spec_u64_to_le_bytes.?
             x$
           ))
          ) 8
         )
         (= (vstd!bytes.spec_u64_from_le_bytes.? (Poly%vstd!seq.Seq<u8.>. (vstd!bytes.spec_u64_to_le_bytes.?
             x$
           ))
          ) (%I x$)
       )))
       :pattern ((vstd!bytes.spec_u64_to_le_bytes.? x$))
       :qid user_vstd__bytes__lemma_auto_spec_u64_to_from_le_bytes_29
       :skolemid skolem_user_vstd__bytes__lemma_auto_spec_u64_to_from_le_bytes_29
     ))
     (forall ((s$ Poly)) (!
       (=>
        (has_type s$ (TYPE%vstd!seq.Seq. $ (UINT 8)))
        (=>
         (= (vstd!seq.Seq.len.? $ (UINT 8) s$) 8)
         (= (vstd!bytes.spec_u64_to_le_bytes.? (I (vstd!bytes.spec_u64_from_le_bytes.? s$)))
          (%Poly%vstd!seq.Seq<u8.>. s$)
       )))
       :pattern ((vstd!bytes.spec_u64_to_le_bytes.? (I (vstd!bytes.spec_u64_from_le_bytes.?
           s$
       ))))
       :qid user_vstd__bytes__lemma_auto_spec_u64_to_from_le_bytes_30
       :skolemid skolem_user_vstd__bytes__lemma_auto_spec_u64_to_from_le_bytes_30
   ))))
   :pattern ((ens%vstd!bytes.lemma_auto_spec_u64_to_from_le_bytes. no%param))
   :qid internal_ens__vstd!bytes.lemma_auto_spec_u64_to_from_le_bytes._definition
   :skolemid skolem_internal_ens__vstd!bytes.lemma_auto_spec_u64_to_from_le_bytes._definition
)))

;; Function-Specs vstd::bytes::u64_from_le_bytes
(declare-fun req%vstd!bytes.u64_from_le_bytes. (slice%<u8.>.) Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((s! slice%<u8.>.)) (!
   (= (req%vstd!bytes.u64_from_le_bytes. s!) (=>
     %%global_location_label%%7
     (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) (
         Poly%slice%<u8.>. s!
       ))
      ) 8
   )))
   :pattern ((req%vstd!bytes.u64_from_le_bytes. s!))
   :qid internal_req__vstd!bytes.u64_from_le_bytes._definition
   :skolemid skolem_internal_req__vstd!bytes.u64_from_le_bytes._definition
)))
(declare-fun ens%vstd!bytes.u64_from_le_bytes. (slice%<u8.>. Int) Bool)
(assert
 (forall ((s! slice%<u8.>.) (x! Int)) (!
   (= (ens%vstd!bytes.u64_from_le_bytes. s! x!) (and
     (uInv 64 x!)
     (= x! (vstd!bytes.spec_u64_from_le_bytes.? (vstd!view.View.view.? $slice (SLICE $ (UINT
          8
         )
        ) (Poly%slice%<u8.>. s!)
   )))))
   :pattern ((ens%vstd!bytes.u64_from_le_bytes. s! x!))
   :qid internal_ens__vstd!bytes.u64_from_le_bytes._definition
   :skolemid skolem_internal_ens__vstd!bytes.u64_from_le_bytes._definition
)))

;; Function-Specs vstd::bytes::u64_to_le_bytes
(declare-fun ens%vstd!bytes.u64_to_le_bytes. (Int alloc!vec.Vec<u8./allocator_global%.>.)
 Bool
)
(assert
 (forall ((x! Int) (s! alloc!vec.Vec<u8./allocator_global%.>.)) (!
   (= (ens%vstd!bytes.u64_to_le_bytes. x! s!) (and
     (= (%Poly%vstd!seq.Seq<u8.>. (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (UINT 8)
         $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<u8./allocator_global%.>. s!)
       )
      ) (vstd!bytes.spec_u64_to_le_bytes.? (I x!))
     )
     (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (UINT
          8
         ) $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<u8./allocator_global%.>. s!)
       )
      ) 8
   )))
   :pattern ((ens%vstd!bytes.u64_to_le_bytes. x! s!))
   :qid internal_ens__vstd!bytes.u64_to_le_bytes._definition
   :skolemid skolem_internal_ens__vstd!bytes.u64_to_le_bytes._definition
)))

;; Function-Specs vstd::slice::slice_subrange
(declare-fun req%vstd!slice.slice_subrange. (Dcr Type Poly Int Int) Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (slice! Poly) (i! Int) (j! Int)) (!
   (= (req%vstd!slice.slice_subrange. T&. T& slice! i! j!) (=>
     %%global_location_label%%8
     (let
      ((tmp%%$ i!))
      (let
       ((tmp%%$1 j!))
       (and
        (and
         (<= 0 tmp%%$)
         (<= tmp%%$ tmp%%$1)
        )
        (<= tmp%%$1 (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
           slice!
   ))))))))
   :pattern ((req%vstd!slice.slice_subrange. T&. T& slice! i! j!))
   :qid internal_req__vstd!slice.slice_subrange._definition
   :skolemid skolem_internal_req__vstd!slice.slice_subrange._definition
)))
(declare-fun ens%vstd!slice.slice_subrange. (Dcr Type Poly Int Int Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (slice! Poly) (i! Int) (j! Int) (out! Poly)) (!
   (= (ens%vstd!slice.slice_subrange. T&. T& slice! i! j! out!) (and
     (has_type out! (SLICE T&. T&))
     (= (vstd!view.View.view.? $slice (SLICE T&. T&) out!) (vstd!seq.Seq.subrange.? T&.
       T& (vstd!view.View.view.? $slice (SLICE T&. T&) slice!) (I i!) (I j!)
   ))))
   :pattern ((ens%vstd!slice.slice_subrange. T&. T& slice! i! j! out!))
   :qid internal_ens__vstd!slice.slice_subrange._definition
   :skolemid skolem_internal_ens__vstd!slice.slice_subrange._definition
)))

;; Function-Axioms pmemlog::pmemspec_t::PersistentMemory::view
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (pmemlog!pmemspec_t.PersistentMemory.view.? Self%&. Self%& self!) (TYPE%vstd!seq.Seq.
      $ (UINT 8)
   )))
   :pattern ((pmemlog!pmemspec_t.PersistentMemory.view.? Self%&. Self%& self!))
   :qid internal_pmemlog!pmemspec_t.PersistentMemory.view.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!pmemspec_t.PersistentMemory.view.?_pre_post_definition
)))

;; Function-Axioms pmemlog::pmemspec_t::PersistentMemory::inv
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (pmemlog!pmemspec_t.PersistentMemory.inv.? Self%&. Self%& self!) BOOL)
   )
   :pattern ((pmemlog!pmemspec_t.PersistentMemory.inv.? Self%&. Self%& self!))
   :qid internal_pmemlog!pmemspec_t.PersistentMemory.inv.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!pmemspec_t.PersistentMemory.inv.?_pre_post_definition
)))

;; Function-Axioms pmemlog::pmemspec_t::PersistentMemory::constants
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (pmemlog!pmemspec_t.PersistentMemory.constants.? Self%&. Self%& self!) TYPE%pmemlog!pmemspec_t.PersistentMemoryConstants.)
   )
   :pattern ((pmemlog!pmemspec_t.PersistentMemory.constants.? Self%&. Self%& self!))
   :qid internal_pmemlog!pmemspec_t.PersistentMemory.constants.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!pmemspec_t.PersistentMemory.constants.?_pre_post_definition
)))

;; Function-Axioms pmemlog::pmemspec_t::maybe_corrupted
(assert
 (fuel_bool_default fuel%pmemlog!pmemspec_t.maybe_corrupted.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!pmemspec_t.maybe_corrupted.)
  (forall ((bytes! Poly) (true_bytes! Poly) (addrs! Poly)) (!
    (= (pmemlog!pmemspec_t.maybe_corrupted.? bytes! true_bytes! addrs!) (and
      (let
       ((tmp%%$ (vstd!seq.Seq.len.? $ (UINT 8) true_bytes!)))
       (and
        (= (vstd!seq.Seq.len.? $ (UINT 8) bytes!) tmp%%$)
        (= tmp%%$ (vstd!seq.Seq.len.? $ INT addrs!))
      ))
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (vstd!seq.Seq.len.? $ (UINT 8) bytes!))
          ))
          (pmemlog!pmemspec_t.maybe_corrupted_byte.? (vstd!seq.Seq.index.? $ (UINT 8) bytes!
            i$
           ) (vstd!seq.Seq.index.? $ (UINT 8) true_bytes! i$) (vstd!seq.Seq.index.? $ INT addrs!
            i$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) bytes! i$))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) true_bytes! i$))
        :pattern ((vstd!seq.Seq.index.? $ INT addrs! i$))
        :qid user_pmemlog__pmemspec_t__maybe_corrupted_31
        :skolemid skolem_user_pmemlog__pmemspec_t__maybe_corrupted_31
    ))))
    :pattern ((pmemlog!pmemspec_t.maybe_corrupted.? bytes! true_bytes! addrs!))
    :qid internal_pmemlog!pmemspec_t.maybe_corrupted.?_definition
    :skolemid skolem_internal_pmemlog!pmemspec_t.maybe_corrupted.?_definition
))))

;; Function-Specs pmemlog::pmemspec_t::PersistentMemory::read
(declare-fun req%pmemlog!pmemspec_t.PersistentMemory.read. (Dcr Type Poly Poly Poly)
 Bool
)
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (addr! Poly) (num_bytes! Poly))
  (!
   (= (req%pmemlog!pmemspec_t.PersistentMemory.read. Self%&. Self%& self! addr! num_bytes!)
    (and
     (=>
      %%global_location_label%%9
      (%B (pmemlog!pmemspec_t.PersistentMemory.inv.? Self%&. Self%& self!))
     )
     (=>
      %%global_location_label%%10
      (<= (Add (%I addr!) (%I num_bytes!)) (vstd!seq.Seq.len.? $ (UINT 8) (pmemlog!pmemspec_t.PersistentMemory.view.?
         Self%&. Self%& self!
   ))))))
   :pattern ((req%pmemlog!pmemspec_t.PersistentMemory.read. Self%&. Self%& self! addr!
     num_bytes!
   ))
   :qid internal_req__pmemlog!pmemspec_t.PersistentMemory.read._definition
   :skolemid skolem_internal_req__pmemlog!pmemspec_t.PersistentMemory.read._definition
)))
(declare-fun ens%pmemlog!pmemspec_t.PersistentMemory.read. (Dcr Type Poly Poly Poly
  Poly
 ) Bool
)
(declare-fun %%lambda%%0 (Int) %%Function%%)
(assert
 (forall ((%%hole%%0 Int) (i$ Poly)) (!
   (= (%%apply%%0 (%%lambda%%0 %%hole%%0) i$) (I (Add (%I i$) %%hole%%0)))
   :pattern ((%%apply%%0 (%%lambda%%0 %%hole%%0) i$))
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (addr! Poly) (num_bytes! Poly) (bytes!
    Poly
   )
  ) (!
   (= (ens%pmemlog!pmemspec_t.PersistentMemory.read. Self%&. Self%& self! addr! num_bytes!
     bytes!
    ) (and
     (has_type bytes! (TYPE%alloc!vec.Vec. $ (UINT 8) $ ALLOCATOR_GLOBAL))
     (let
      ((true_bytes$ (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.subrange.? $ (UINT 8) (pmemlog!pmemspec_t.PersistentMemory.view.?
           Self%&. Self%& self!
          ) addr! (I (Add (%I addr!) (%I num_bytes!)))
      ))))
      (let
       ((addrs$ (%Poly%vstd!seq.Seq<int.>. (vstd!seq.Seq.new.? $ INT $ (TYPE%fun%1. $ INT $ INT)
           num_bytes! (Poly%fun%1. (mk_fun (%%lambda%%0 (%I addr!))))
       ))))
       (ite
        (pmemlog!pmemspec_t.PersistentMemoryConstants./PersistentMemoryConstants/impervious_to_corruption
         (%Poly%pmemlog!pmemspec_t.PersistentMemoryConstants. (pmemlog!pmemspec_t.PersistentMemory.constants.?
           Self%&. Self%& self!
        )))
        (= (%Poly%vstd!seq.Seq<u8.>. (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (UINT 8)
            $ ALLOCATOR_GLOBAL
           ) bytes!
          )
         ) true_bytes$
        )
        (pmemlog!pmemspec_t.maybe_corrupted.? (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
           $ (UINT 8) $ ALLOCATOR_GLOBAL
          ) bytes!
         ) (Poly%vstd!seq.Seq<u8.>. true_bytes$) (Poly%vstd!seq.Seq<int.>. addrs$)
   ))))))
   :pattern ((ens%pmemlog!pmemspec_t.PersistentMemory.read. Self%&. Self%& self! addr!
     num_bytes! bytes!
   ))
   :qid internal_ens__pmemlog!pmemspec_t.PersistentMemory.read._definition
   :skolemid skolem_internal_ens__pmemlog!pmemspec_t.PersistentMemory.read._definition
)))

;; Function-Axioms pmemlog::pmemspec_t::update_byte_to_reflect_write
(assert
 (fuel_bool_default fuel%pmemlog!pmemspec_t.update_byte_to_reflect_write.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!pmemspec_t.update_byte_to_reflect_write.)
  (forall ((addr! Poly) (prewrite_byte! Poly) (write_addr! Poly) (write_bytes! Poly))
   (!
    (= (pmemlog!pmemspec_t.update_byte_to_reflect_write.? addr! prewrite_byte! write_addr!
      write_bytes!
     ) (%I (ite
       (and
        (<= (%I write_addr!) (%I addr!))
        (< (%I addr!) (Add (%I write_addr!) (vstd!seq.Seq.len.? $ (UINT 8) write_bytes!)))
       )
       (vstd!seq.Seq.index.? $ (UINT 8) write_bytes! (I (Sub (%I addr!) (%I write_addr!))))
       prewrite_byte!
    )))
    :pattern ((pmemlog!pmemspec_t.update_byte_to_reflect_write.? addr! prewrite_byte! write_addr!
      write_bytes!
    ))
    :qid internal_pmemlog!pmemspec_t.update_byte_to_reflect_write.?_definition
    :skolemid skolem_internal_pmemlog!pmemspec_t.update_byte_to_reflect_write.?_definition
))))
(assert
 (forall ((addr! Poly) (prewrite_byte! Poly) (write_addr! Poly) (write_bytes! Poly))
  (!
   (=>
    (and
     (has_type addr! INT)
     (has_type prewrite_byte! (UINT 8))
     (has_type write_addr! INT)
     (has_type write_bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    )
    (uInv 8 (pmemlog!pmemspec_t.update_byte_to_reflect_write.? addr! prewrite_byte! write_addr!
      write_bytes!
   )))
   :pattern ((pmemlog!pmemspec_t.update_byte_to_reflect_write.? addr! prewrite_byte! write_addr!
     write_bytes!
   ))
   :qid internal_pmemlog!pmemspec_t.update_byte_to_reflect_write.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!pmemspec_t.update_byte_to_reflect_write.?_pre_post_definition
)))

;; Function-Specs pmemlog::pmemspec_t::update_contents_to_reflect_write
(declare-fun req%pmemlog!pmemspec_t.update_contents_to_reflect_write. (Poly Poly Poly)
 Bool
)
(declare-const %%global_location_label%%11 Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((prewrite_contents! Poly) (write_addr! Poly) (write_bytes! Poly)) (!
   (= (req%pmemlog!pmemspec_t.update_contents_to_reflect_write. prewrite_contents! write_addr!
     write_bytes!
    ) (and
     (=>
      %%global_location_label%%11
      (<= 0 (%I write_addr!))
     )
     (=>
      %%global_location_label%%12
      (<= (Add (%I write_addr!) (vstd!seq.Seq.len.? $ (UINT 8) write_bytes!)) (vstd!seq.Seq.len.?
        $ (UINT 8) prewrite_contents!
   )))))
   :pattern ((req%pmemlog!pmemspec_t.update_contents_to_reflect_write. prewrite_contents!
     write_addr! write_bytes!
   ))
   :qid internal_req__pmemlog!pmemspec_t.update_contents_to_reflect_write._definition
   :skolemid skolem_internal_req__pmemlog!pmemspec_t.update_contents_to_reflect_write._definition
)))

;; Function-Axioms pmemlog::pmemspec_t::update_contents_to_reflect_write
(assert
 (fuel_bool_default fuel%pmemlog!pmemspec_t.update_contents_to_reflect_write.)
)
(declare-fun %%lambda%%1 (Dcr Type Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   ) (addr$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4) addr$)
    (I (pmemlog!pmemspec_t.update_byte_to_reflect_write.? addr$ (vstd!seq.Seq.index.? %%hole%%0
       %%hole%%1 %%hole%%2 addr$
      ) %%hole%%3 %%hole%%4
   )))
   :pattern ((%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)
     addr$
)))))
(assert
 (=>
  (fuel_bool fuel%pmemlog!pmemspec_t.update_contents_to_reflect_write.)
  (forall ((prewrite_contents! Poly) (write_addr! Poly) (write_bytes! Poly)) (!
    (= (pmemlog!pmemspec_t.update_contents_to_reflect_write.? prewrite_contents! write_addr!
      write_bytes!
     ) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.new.? $ (UINT 8) $ (TYPE%fun%1. $ INT $ (UINT
         8
        )
       ) (I (vstd!seq.Seq.len.? $ (UINT 8) prewrite_contents!)) (Poly%fun%1. (mk_fun (%%lambda%%1
          $ (UINT 8) prewrite_contents! write_addr! write_bytes!
    ))))))
    :pattern ((pmemlog!pmemspec_t.update_contents_to_reflect_write.? prewrite_contents!
      write_addr! write_bytes!
    ))
    :qid internal_pmemlog!pmemspec_t.update_contents_to_reflect_write.?_definition
    :skolemid skolem_internal_pmemlog!pmemspec_t.update_contents_to_reflect_write.?_definition
))))

;; Function-Specs pmemlog::pmemspec_t::PersistentMemory::write
(declare-fun req%pmemlog!pmemspec_t.PersistentMemory.write. (Dcr Type Poly Poly Poly)
 Bool
)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (pre%self! Poly) (addr! Poly) (bytes! Poly))
  (!
   (= (req%pmemlog!pmemspec_t.PersistentMemory.write. Self%&. Self%& pre%self! addr! bytes!)
    (and
     (=>
      %%global_location_label%%13
      (%B (pmemlog!pmemspec_t.PersistentMemory.inv.? Self%&. Self%& pre%self!))
     )
     (=>
      %%global_location_label%%14
      (<= (Add (%I addr!) (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE
           $ (UINT 8)
          ) bytes!
        ))
       ) (vstd!seq.Seq.len.? $ (UINT 8) (pmemlog!pmemspec_t.PersistentMemory.view.? Self%&.
         Self%& pre%self!
     ))))
     (=>
      %%global_location_label%%15
      (<= (Add (%I addr!) (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE
           $ (UINT 8)
          ) bytes!
        ))
       ) 18446744073709551615
   ))))
   :pattern ((req%pmemlog!pmemspec_t.PersistentMemory.write. Self%&. Self%& pre%self!
     addr! bytes!
   ))
   :qid internal_req__pmemlog!pmemspec_t.PersistentMemory.write._definition
   :skolemid skolem_internal_req__pmemlog!pmemspec_t.PersistentMemory.write._definition
)))
(declare-fun ens%pmemlog!pmemspec_t.PersistentMemory.write. (Dcr Type Poly Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (pre%self! Poly) (self! Poly) (addr! Poly) (bytes!
    Poly
   )
  ) (!
   (= (ens%pmemlog!pmemspec_t.PersistentMemory.write. Self%&. Self%& pre%self! self! addr!
     bytes!
    ) (and
     (has_type self! Self%&)
     (%B (pmemlog!pmemspec_t.PersistentMemory.inv.? Self%&. Self%& self!))
     (= (pmemlog!pmemspec_t.PersistentMemory.constants.? Self%&. Self%& self!) (pmemlog!pmemspec_t.PersistentMemory.constants.?
       Self%&. Self%& pre%self!
     ))
     (= (%Poly%vstd!seq.Seq<u8.>. (pmemlog!pmemspec_t.PersistentMemory.view.? Self%&. Self%&
        self!
       )
      ) (pmemlog!pmemspec_t.update_contents_to_reflect_write.? (pmemlog!pmemspec_t.PersistentMemory.view.?
        Self%&. Self%& pre%self!
       ) addr! (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) bytes!)
   ))))
   :pattern ((ens%pmemlog!pmemspec_t.PersistentMemory.write. Self%&. Self%& pre%self!
     self! addr! bytes!
   ))
   :qid internal_ens__pmemlog!pmemspec_t.PersistentMemory.write._definition
   :skolemid skolem_internal_ens__pmemlog!pmemspec_t.PersistentMemory.write._definition
)))

;; Function-Axioms pmemlog::pmemspec_t::crc_size
(assert
 (fuel_bool_default fuel%pmemlog!pmemspec_t.crc_size.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!pmemspec_t.crc_size.)
  (= pmemlog!pmemspec_t.crc_size.? 8)
))
(assert
 (uInv 64 pmemlog!pmemspec_t.crc_size.?)
)

;; Function-Specs pmemlog::pmemspec_t::bytes_crc
(declare-fun ens%pmemlog!pmemspec_t.bytes_crc. (alloc!vec.Vec<u8./allocator_global%.>.
  alloc!vec.Vec<u8./allocator_global%.>.
 ) Bool
)
(assert
 (forall ((header_bytes! alloc!vec.Vec<u8./allocator_global%.>.) (out! alloc!vec.Vec<u8./allocator_global%.>.))
  (!
   (= (ens%pmemlog!pmemspec_t.bytes_crc. header_bytes! out!) (and
     (= (pmemlog!pmemspec_t.spec_crc_bytes.? (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
         $ (UINT 8) $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<u8./allocator_global%.>. header_bytes!)
       )
      ) (%Poly%vstd!seq.Seq<u8.>. (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (UINT 8)
         $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<u8./allocator_global%.>. out!)
     )))
     (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (UINT
          8
         ) $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<u8./allocator_global%.>. out!)
       )
      ) pmemlog!pmemspec_t.crc_size.?
   )))
   :pattern ((ens%pmemlog!pmemspec_t.bytes_crc. header_bytes! out!))
   :qid internal_ens__pmemlog!pmemspec_t.bytes_crc._definition
   :skolemid skolem_internal_ens__pmemlog!pmemspec_t.bytes_crc._definition
)))

;; Function-Axioms pmemlog::pmemspec_t::all_elements_unique
(assert
 (fuel_bool_default fuel%pmemlog!pmemspec_t.all_elements_unique.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!pmemspec_t.all_elements_unique.)
  (forall ((seq! Poly)) (!
    (= (pmemlog!pmemspec_t.all_elements_unique.? seq!) (forall ((i$ Poly) (j$ Poly)) (!
       (=>
        (and
         (has_type i$ INT)
         (has_type j$ INT)
        )
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (let
           ((tmp%%$1 (%I j$)))
           (and
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ tmp%%$1)
            )
            (< tmp%%$1 (vstd!seq.Seq.len.? $ INT seq!))
         )))
         (not (= (vstd!seq.Seq.index.? $ INT seq! i$) (vstd!seq.Seq.index.? $ INT seq! j$)))
       ))
       :pattern ((vstd!seq.Seq.index.? $ INT seq! i$) (vstd!seq.Seq.index.? $ INT seq! j$))
       :qid user_pmemlog__pmemspec_t__all_elements_unique_32
       :skolemid skolem_user_pmemlog__pmemspec_t__all_elements_unique_32
    )))
    :pattern ((pmemlog!pmemspec_t.all_elements_unique.? seq!))
    :qid internal_pmemlog!pmemspec_t.all_elements_unique.?_definition
    :skolemid skolem_internal_pmemlog!pmemspec_t.all_elements_unique.?_definition
))))

;; Function-Specs pmemlog::pmemspec_t::axiom_bytes_uncorrupted
(declare-fun req%pmemlog!pmemspec_t.axiom_bytes_uncorrupted. (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.
  vstd!seq.Seq<int.>. vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>. vstd!seq.Seq<int.>.
 ) Bool
)
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((x_c! vstd!seq.Seq<u8.>.) (x! vstd!seq.Seq<u8.>.) (x_addrs! vstd!seq.Seq<int.>.)
   (y_c! vstd!seq.Seq<u8.>.) (y! vstd!seq.Seq<u8.>.) (y_addrs! vstd!seq.Seq<int.>.)
  ) (!
   (= (req%pmemlog!pmemspec_t.axiom_bytes_uncorrupted. x_c! x! x_addrs! y_c! y! y_addrs!)
    (and
     (=>
      %%global_location_label%%16
      (pmemlog!pmemspec_t.maybe_corrupted.? (Poly%vstd!seq.Seq<u8.>. x_c!) (Poly%vstd!seq.Seq<u8.>.
        x!
       ) (Poly%vstd!seq.Seq<int.>. x_addrs!)
     ))
     (=>
      %%global_location_label%%17
      (pmemlog!pmemspec_t.maybe_corrupted.? (Poly%vstd!seq.Seq<u8.>. y_c!) (Poly%vstd!seq.Seq<u8.>.
        y!
       ) (Poly%vstd!seq.Seq<int.>. y_addrs!)
     ))
     (=>
      %%global_location_label%%18
      (= y! (pmemlog!pmemspec_t.spec_crc_bytes.? (Poly%vstd!seq.Seq<u8.>. x!)))
     )
     (=>
      %%global_location_label%%19
      (= y_c! (pmemlog!pmemspec_t.spec_crc_bytes.? (Poly%vstd!seq.Seq<u8.>. x_c!)))
     )
     (=>
      %%global_location_label%%20
      (pmemlog!pmemspec_t.all_elements_unique.? (Poly%vstd!seq.Seq<int.>. x_addrs!))
     )
     (=>
      %%global_location_label%%21
      (pmemlog!pmemspec_t.all_elements_unique.? (Poly%vstd!seq.Seq<int.>. y_addrs!))
   )))
   :pattern ((req%pmemlog!pmemspec_t.axiom_bytes_uncorrupted. x_c! x! x_addrs! y_c! y!
     y_addrs!
   ))
   :qid internal_req__pmemlog!pmemspec_t.axiom_bytes_uncorrupted._definition
   :skolemid skolem_internal_req__pmemlog!pmemspec_t.axiom_bytes_uncorrupted._definition
)))
(declare-fun ens%pmemlog!pmemspec_t.axiom_bytes_uncorrupted. (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.
  vstd!seq.Seq<int.>. vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>. vstd!seq.Seq<int.>.
 ) Bool
)
(assert
 (forall ((x_c! vstd!seq.Seq<u8.>.) (x! vstd!seq.Seq<u8.>.) (x_addrs! vstd!seq.Seq<int.>.)
   (y_c! vstd!seq.Seq<u8.>.) (y! vstd!seq.Seq<u8.>.) (y_addrs! vstd!seq.Seq<int.>.)
  ) (!
   (= (ens%pmemlog!pmemspec_t.axiom_bytes_uncorrupted. x_c! x! x_addrs! y_c! y! y_addrs!)
    (= x! x_c!)
   )
   :pattern ((ens%pmemlog!pmemspec_t.axiom_bytes_uncorrupted. x_c! x! x_addrs! y_c! y!
     y_addrs!
   ))
   :qid internal_ens__pmemlog!pmemspec_t.axiom_bytes_uncorrupted._definition
   :skolemid skolem_internal_ens__pmemlog!pmemspec_t.axiom_bytes_uncorrupted._definition
)))

;; Function-Axioms pmemlog::pmemspec_t::cdb0_val
(assert
 (fuel_bool_default fuel%pmemlog!pmemspec_t.cdb0_val.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!pmemspec_t.cdb0_val.)
  (= pmemlog!pmemspec_t.cdb0_val.? 11756720295082287198)
))
(assert
 (uInv 64 pmemlog!pmemspec_t.cdb0_val.?)
)

;; Function-Axioms pmemlog::pmemspec_t::cdb1_val
(assert
 (fuel_bool_default fuel%pmemlog!pmemspec_t.cdb1_val.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!pmemspec_t.cdb1_val.)
  (= pmemlog!pmemspec_t.cdb1_val.? 12331324665725530551)
))
(assert
 (uInv 64 pmemlog!pmemspec_t.cdb1_val.?)
)

;; Function-Specs pmemlog::pmemspec_t::axiom_corruption_detecting_boolean
(declare-fun req%pmemlog!pmemspec_t.axiom_corruption_detecting_boolean. (Int Int vstd!seq.Seq<int.>.)
 Bool
)
(declare-const %%global_location_label%%22 Bool)
(declare-const %%global_location_label%%23 Bool)
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((cdb_c! Int) (cdb! Int) (addrs! vstd!seq.Seq<int.>.)) (!
   (= (req%pmemlog!pmemspec_t.axiom_corruption_detecting_boolean. cdb_c! cdb! addrs!)
    (and
     (=>
      %%global_location_label%%22
      (pmemlog!pmemspec_t.maybe_corrupted.? (Poly%vstd!seq.Seq<u8.>. (vstd!bytes.spec_u64_to_le_bytes.?
         (I cdb_c!)
        )
       ) (Poly%vstd!seq.Seq<u8.>. (vstd!bytes.spec_u64_to_le_bytes.? (I cdb!))) (Poly%vstd!seq.Seq<int.>.
        addrs!
     )))
     (=>
      %%global_location_label%%23
      (pmemlog!pmemspec_t.all_elements_unique.? (Poly%vstd!seq.Seq<int.>. addrs!))
     )
     (=>
      %%global_location_label%%24
      (or
       (= cdb! pmemlog!pmemspec_t.cdb0_val.?)
       (= cdb! pmemlog!pmemspec_t.cdb1_val.?)
     ))
     (=>
      %%global_location_label%%25
      (or
       (= cdb_c! pmemlog!pmemspec_t.cdb0_val.?)
       (= cdb_c! pmemlog!pmemspec_t.cdb1_val.?)
   ))))
   :pattern ((req%pmemlog!pmemspec_t.axiom_corruption_detecting_boolean. cdb_c! cdb! addrs!))
   :qid internal_req__pmemlog!pmemspec_t.axiom_corruption_detecting_boolean._definition
   :skolemid skolem_internal_req__pmemlog!pmemspec_t.axiom_corruption_detecting_boolean._definition
)))
(declare-fun ens%pmemlog!pmemspec_t.axiom_corruption_detecting_boolean. (Int Int vstd!seq.Seq<int.>.)
 Bool
)
(assert
 (forall ((cdb_c! Int) (cdb! Int) (addrs! vstd!seq.Seq<int.>.)) (!
   (= (ens%pmemlog!pmemspec_t.axiom_corruption_detecting_boolean. cdb_c! cdb! addrs!)
    (= cdb_c! cdb!)
   )
   :pattern ((ens%pmemlog!pmemspec_t.axiom_corruption_detecting_boolean. cdb_c! cdb! addrs!))
   :qid internal_ens__pmemlog!pmemspec_t.axiom_corruption_detecting_boolean._definition
   :skolemid skolem_internal_ens__pmemlog!pmemspec_t.axiom_corruption_detecting_boolean._definition
)))

;; Function-Axioms pmemlog::sccf::CheckPermission::check_permission
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (AbstractStorage&. Dcr) (AbstractStorage& Type)
   (self! Poly) (state! Poly)
  ) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type state! AbstractStorage&)
    )
    (has_type (pmemlog!sccf.CheckPermission.check_permission.? Self%&. Self%& AbstractStorage&.
      AbstractStorage& self! state!
     ) BOOL
   ))
   :pattern ((pmemlog!sccf.CheckPermission.check_permission.? Self%&. Self%& AbstractStorage&.
     AbstractStorage& self! state!
   ))
   :qid internal_pmemlog!sccf.CheckPermission.check_permission.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!sccf.CheckPermission.check_permission.?_pre_post_definition
)))

;; Function-Axioms vstd::raw_ptr::impl&%3::view
(assert
 (fuel_bool_default fuel%vstd!raw_ptr.impl&%3.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.impl&%3.view.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (= (vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!) (vstd!view.View.view.?
      $ (PTR T&. T&) self!
    ))
    :pattern ((vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%0.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (REF A&.) A& self!) (vstd!view.View.view.? A&. A& self!))
    )
    :pattern ((vstd!view.View.view.? (REF A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%2::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%2.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%2.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%4::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%4.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%4.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%6::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%6.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%6.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%10::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%10.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%10.view.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!view.View.view.? $ (TYPE%core!option.Option. T&. T&) self!) self!)
    )
    :pattern ((vstd!view.View.view.? $ (TYPE%core!option.Option. T&. T&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%12::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%12.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%12.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ TYPE%tuple%0. self!) self!)
    :pattern ((vstd!view.View.view.? $ TYPE%tuple%0. self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%14::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%14.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%14.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ BOOL self!) self!)
    :pattern ((vstd!view.View.view.? $ BOOL self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%16::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%16.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%16.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 8) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 8) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%22::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%22.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%22.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 64) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 64) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%26::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%26.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%26.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ USIZE self!) self!)
    :pattern ((vstd!view.View.view.? $ USIZE self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%44::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%44.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%44.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (self! Poly)) (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
     )
     (= (vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!) (Poly%tuple%2.
       (tuple%2./tuple%2 (vstd!view.View.view.? A0&. A0& (tuple%2./tuple%2/0 (%Poly%tuple%2.
           self!
         ))
        ) (vstd!view.View.view.? A1&. A1& (tuple%2./tuple%2/1 (%Poly%tuple%2. self!)))
    ))))
    :pattern ((vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%46::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%46.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%46.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (self! Poly))
   (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (sized A2&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
      (tr_bound%vstd!view.View. A2&. A2&)
     )
     (= (vstd!view.View.view.? (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&) self!)
      (Poly%tuple%3. (tuple%3./tuple%3 (vstd!view.View.view.? A0&. A0& (tuple%3./tuple%3/0
          (%Poly%tuple%3. self!)
         )
        ) (vstd!view.View.view.? A1&. A1& (tuple%3./tuple%3/1 (%Poly%tuple%3. self!))) (vstd!view.View.view.?
         A2&. A2& (tuple%3./tuple%3/2 (%Poly%tuple%3. self!))
    )))))
    :pattern ((vstd!view.View.view.? (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&)
      self!
    ))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms pmemlog::infinitelog_t::AbstractInfiniteLogState::initialize
(assert
 (fuel_bool_default fuel%pmemlog!infinitelog_t.impl&%0.initialize.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!infinitelog_t.impl&%0.initialize.)
  (forall ((capacity! Poly)) (!
    (= (pmemlog!infinitelog_t.impl&%0.initialize.? capacity!) (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState
      (%I (I 0)) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.empty.? $ (UINT 8))) (%I capacity!)
    ))
    :pattern ((pmemlog!infinitelog_t.impl&%0.initialize.? capacity!))
    :qid internal_pmemlog!infinitelog_t.impl&__0.initialize.?_definition
    :skolemid skolem_internal_pmemlog!infinitelog_t.impl&__0.initialize.?_definition
))))

;; Function-Axioms pmemlog::infinitelog_t::AbstractInfiniteLogState::append
(assert
 (fuel_bool_default fuel%pmemlog!infinitelog_t.impl&%0.append.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!infinitelog_t.impl&%0.append.)
  (forall ((self! Poly) (bytes! Poly)) (!
    (= (pmemlog!infinitelog_t.impl&%0.append.? self! bytes!) (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState
      (%I (I (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head
         (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. self!)
       ))
      ) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.add.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
         (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState.
           self!
         ))
        ) bytes!
       )
      ) (%I (I (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/capacity
         (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. self!)
    )))))
    :pattern ((pmemlog!infinitelog_t.impl&%0.append.? self! bytes!))
    :qid internal_pmemlog!infinitelog_t.impl&__0.append.?_definition
    :skolemid skolem_internal_pmemlog!infinitelog_t.impl&__0.append.?_definition
))))

;; Function-Axioms pmemlog::infinitelog_t::AbstractInfiniteLogState::advance_head
(assert
 (fuel_bool_default fuel%pmemlog!infinitelog_t.impl&%0.advance_head.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!infinitelog_t.impl&%0.advance_head.)
  (forall ((self! Poly) (new_head! Poly)) (!
    (= (pmemlog!infinitelog_t.impl&%0.advance_head.? self! new_head!) (ite
      (let
       ((tmp%%$ (%I new_head!)))
       (and
        (<= (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head
          (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. self!)
         ) tmp%%$
        )
        (<= tmp%%$ (Add (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head
           (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. self!)
          ) (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log
             (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. self!)
      )))))))
      (let
       ((new_log$ (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
            (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState.
              self!
            ))
           ) (I (Sub (%I new_head!) (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/head
              (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. self!)
            ))
           ) (I (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log
               (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. self!)
       ))))))))
       (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState (%I new_head!)
        (%Poly%vstd!seq.Seq<u8.>. (Poly%vstd!seq.Seq<u8.>. new_log$)) (%I (I (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/capacity
           (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. self!)
      )))))
      (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. self!)
    ))
    :pattern ((pmemlog!infinitelog_t.impl&%0.advance_head.? self! new_head!))
    :qid internal_pmemlog!infinitelog_t.impl&__0.advance_head.?_definition
    :skolemid skolem_internal_pmemlog!infinitelog_t.impl&__0.advance_head.?_definition
))))

;; Function-Axioms pmemlog::logimpl_v::incorruptible_bool_pos
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.incorruptible_bool_pos.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.incorruptible_bool_pos.)
  (= pmemlog!logimpl_v.incorruptible_bool_pos.? 0)
))
(assert
 (uInv 64 pmemlog!logimpl_v.incorruptible_bool_pos.?)
)

;; Function-Axioms pmemlog::logimpl_v::header1_pos
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.header1_pos.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.header1_pos.)
  (= pmemlog!logimpl_v.header1_pos.? 8)
))
(assert
 (uInv 64 pmemlog!logimpl_v.header1_pos.?)
)

;; Function-Axioms pmemlog::logimpl_v::header2_pos
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.header2_pos.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.header2_pos.)
  (= pmemlog!logimpl_v.header2_pos.? 40)
))
(assert
 (uInv 64 pmemlog!logimpl_v.header2_pos.?)
)

;; Function-Axioms pmemlog::logimpl_v::header_crc_offset
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.header_crc_offset.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.header_crc_offset.)
  (= pmemlog!logimpl_v.header_crc_offset.? 0)
))
(assert
 (uInv 64 pmemlog!logimpl_v.header_crc_offset.?)
)

;; Function-Axioms pmemlog::logimpl_v::header_head_offset
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.header_head_offset.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.header_head_offset.)
  (= pmemlog!logimpl_v.header_head_offset.? 8)
))
(assert
 (uInv 64 pmemlog!logimpl_v.header_head_offset.?)
)

;; Function-Axioms pmemlog::logimpl_v::header_tail_offset
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.header_tail_offset.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.header_tail_offset.)
  (= pmemlog!logimpl_v.header_tail_offset.? 16)
))
(assert
 (uInv 64 pmemlog!logimpl_v.header_tail_offset.?)
)

;; Function-Axioms pmemlog::logimpl_v::header_log_size_offset
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.header_log_size_offset.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.header_log_size_offset.)
  (= pmemlog!logimpl_v.header_log_size_offset.? 24)
))
(assert
 (uInv 64 pmemlog!logimpl_v.header_log_size_offset.?)
)

;; Function-Axioms pmemlog::logimpl_v::header_size
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.header_size.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.header_size.)
  (= pmemlog!logimpl_v.header_size.? 32)
))
(assert
 (uInv 64 pmemlog!logimpl_v.header_size.?)
)

;; Function-Specs pmemlog::logimpl_v::spec_bytes_to_metadata
(declare-fun req%pmemlog!logimpl_v.spec_bytes_to_metadata. (Poly) Bool)
(declare-const %%global_location_label%%26 Bool)
(assert
 (forall ((header_seq! Poly)) (!
   (= (req%pmemlog!logimpl_v.spec_bytes_to_metadata. header_seq!) (=>
     %%global_location_label%%26
     (= (vstd!seq.Seq.len.? $ (UINT 8) header_seq!) (nClip (Mul 3 8)))
   ))
   :pattern ((req%pmemlog!logimpl_v.spec_bytes_to_metadata. header_seq!))
   :qid internal_req__pmemlog!logimpl_v.spec_bytes_to_metadata._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.spec_bytes_to_metadata._definition
)))

;; Function-Axioms pmemlog::logimpl_v::spec_bytes_to_metadata
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.spec_bytes_to_metadata.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.spec_bytes_to_metadata.)
  (forall ((header_seq! Poly)) (!
    (= (pmemlog!logimpl_v.spec_bytes_to_metadata.? header_seq!) (let
      ((head$ (vstd!bytes.spec_u64_from_le_bytes.? (vstd!seq.Seq.subrange.? $ (UINT 8) header_seq!
          (I (Sub pmemlog!logimpl_v.header_head_offset.? 8)) (I (Add (Sub pmemlog!logimpl_v.header_head_offset.?
             8
            ) 8
      ))))))
      (let
       ((tail$ (vstd!bytes.spec_u64_from_le_bytes.? (vstd!seq.Seq.subrange.? $ (UINT 8) header_seq!
           (I (Sub pmemlog!logimpl_v.header_tail_offset.? 8)) (I (Add (Sub pmemlog!logimpl_v.header_tail_offset.?
              8
             ) 8
       ))))))
       (let
        ((log_size$ (vstd!bytes.spec_u64_from_le_bytes.? (vstd!seq.Seq.subrange.? $ (UINT 8)
            header_seq! (I (Sub pmemlog!logimpl_v.header_log_size_offset.? 8)) (I (Add (Sub pmemlog!logimpl_v.header_log_size_offset.?
               8
              ) 8
        ))))))
        (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata (%I (I head$))
         (%I (I tail$)) (%I (I log_size$))
    )))))
    :pattern ((pmemlog!logimpl_v.spec_bytes_to_metadata.? header_seq!))
    :qid internal_pmemlog!logimpl_v.spec_bytes_to_metadata.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.spec_bytes_to_metadata.?_definition
))))
(assert
 (forall ((header_seq! Poly)) (!
   (=>
    (has_type header_seq! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (has_type (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (pmemlog!logimpl_v.spec_bytes_to_metadata.?
       header_seq!
      )
     ) TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.
   ))
   :pattern ((pmemlog!logimpl_v.spec_bytes_to_metadata.? header_seq!))
   :qid internal_pmemlog!logimpl_v.spec_bytes_to_metadata.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.spec_bytes_to_metadata.?_pre_post_definition
)))

;; Function-Axioms pmemlog::logimpl_v::contents_offset
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.contents_offset.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.contents_offset.)
  (= pmemlog!logimpl_v.contents_offset.? (uClip 64 (Add (uClip 64 (Add pmemlog!logimpl_v.header2_pos.?
       pmemlog!logimpl_v.header_log_size_offset.?
      )
     ) 8
)))))
(assert
 (uInv 64 pmemlog!logimpl_v.contents_offset.?)
)

;; Function-Axioms pmemlog::logimpl_v::pm_to_views
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.pm_to_views.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.pm_to_views.)
  (forall ((pm! Poly)) (!
    (= (pmemlog!logimpl_v.pm_to_views.? pm!) (let
      ((incorruptible_bool$ (vstd!bytes.spec_u64_from_le_bytes.? (vstd!seq.Seq.subrange.? $
          (UINT 8) pm! (I pmemlog!logimpl_v.incorruptible_bool_pos.?) (I (Add pmemlog!logimpl_v.incorruptible_bool_pos.?
            8
      ))))))
      (let
       ((crc1$ (vstd!bytes.spec_u64_from_le_bytes.? (vstd!seq.Seq.subrange.? $ (UINT 8) pm!
           (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_crc_offset.?)) (
            I (Add (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_crc_offset.?)
             8
       ))))))
       (let
        ((crc2$ (vstd!bytes.spec_u64_from_le_bytes.? (vstd!seq.Seq.subrange.? $ (UINT 8) pm!
            (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_crc_offset.?)) (
             I (Add (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_crc_offset.?)
              8
        ))))))
        (let
         ((header1_metadata$ (pmemlog!logimpl_v.spec_bytes_to_metadata.? (vstd!seq.Seq.subrange.?
             $ (UINT 8) pm! (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_head_offset.?))
             (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_size.?))
         ))))
         (let
          ((header2_metadata$ (pmemlog!logimpl_v.spec_bytes_to_metadata.? (vstd!seq.Seq.subrange.?
              $ (UINT 8) pm! (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_head_offset.?))
              (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_size.?))
          ))))
          (let
           ((header_view$ (pmemlog!logimpl_v.HeaderView./HeaderView (%Poly%pmemlog!logimpl_v.PersistentHeader.
               (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.PersistentHeader./PersistentHeader
                 (%I (I crc1$)) (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                   header1_metadata$
               ))))
              ) (%Poly%pmemlog!logimpl_v.PersistentHeader. (Poly%pmemlog!logimpl_v.PersistentHeader.
                (pmemlog!logimpl_v.PersistentHeader./PersistentHeader (%I (I crc2$)) (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                  (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. header2_metadata$)
           )))))))
           (let
            ((data_view$ (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.subrange.? $ (UINT 8) pm! (I pmemlog!logimpl_v.contents_offset.?)
                (I (vstd!seq.Seq.len.? $ (UINT 8) pm!))
            ))))
            (tuple%3./tuple%3 (I incorruptible_bool$) (Poly%pmemlog!logimpl_v.HeaderView. header_view$)
             (Poly%vstd!seq.Seq<u8.>. data_view$)
    )))))))))
    :pattern ((pmemlog!logimpl_v.pm_to_views.? pm!))
    :qid internal_pmemlog!logimpl_v.pm_to_views.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.pm_to_views.?_definition
))))
(assert
 (forall ((pm! Poly)) (!
   (=>
    (has_type pm! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (has_type (Poly%tuple%3. (pmemlog!logimpl_v.pm_to_views.? pm!)) (TYPE%tuple%3. $ (UINT
       64
      ) $ TYPE%pmemlog!logimpl_v.HeaderView. $ (TYPE%vstd!seq.Seq. $ (UINT 8))
   )))
   :pattern ((pmemlog!logimpl_v.pm_to_views.? pm!))
   :qid internal_pmemlog!logimpl_v.pm_to_views.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.pm_to_views.?_pre_post_definition
)))

;; Function-Axioms pmemlog::logimpl_v::spec_get_live_header
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.spec_get_live_header.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.spec_get_live_header.)
  (forall ((pm! Poly)) (!
    (= (pmemlog!logimpl_v.spec_get_live_header.? pm!) (let
      ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? pm!)))
      (let
       ((ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3.
              tmp%%$
        ))))))
        (ite
         (= ib$ pmemlog!pmemspec_t.cdb0_val.?)
         (pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
           (Poly%pmemlog!logimpl_v.HeaderView. headers$)
         ))
         (pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
           (Poly%pmemlog!logimpl_v.HeaderView. headers$)
    )))))))
    :pattern ((pmemlog!logimpl_v.spec_get_live_header.? pm!))
    :qid internal_pmemlog!logimpl_v.spec_get_live_header.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.spec_get_live_header.?_definition
))))
(assert
 (forall ((pm! Poly)) (!
   (=>
    (has_type pm! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (has_type (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.spec_get_live_header.?
       pm!
      )
     ) TYPE%pmemlog!logimpl_v.PersistentHeader.
   ))
   :pattern ((pmemlog!logimpl_v.spec_get_live_header.? pm!))
   :qid internal_pmemlog!logimpl_v.spec_get_live_header.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.spec_get_live_header.?_pre_post_definition
)))

;; Function-Axioms pmemlog::logimpl_v::UntrustedLogImpl::log_state_is_valid
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.impl&%0.log_state_is_valid.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.impl&%0.log_state_is_valid.)
  (forall ((pm! Poly)) (!
    (= (pmemlog!logimpl_v.impl&%0.log_state_is_valid.? pm!) (let
      ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? pm!)))
      (let
       ((ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3.
              tmp%%$
        ))))))
        (let
         ((data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
         (let
          ((live_header$ (ite
             (= ib$ pmemlog!pmemspec_t.cdb0_val.?)
             (pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
               (Poly%pmemlog!logimpl_v.HeaderView. headers$)
             ))
             (pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
               (Poly%pmemlog!logimpl_v.HeaderView. headers$)
          )))))
          (let
           ((head$ (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head (
               %Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                  (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
           )))))))
           (let
            ((tail$ (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail (
                %Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                 (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                   (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
            )))))))
            (let
             ((log_size$ (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                  (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                    (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
             )))))))
             (and
              (and
               (and
                (and
                 (and
                  (and
                   (and
                    (or
                     (= ib$ pmemlog!pmemspec_t.cdb0_val.?)
                     (= ib$ pmemlog!pmemspec_t.cdb1_val.?)
                    )
                    (<= (Add log_size$ pmemlog!logimpl_v.contents_offset.?) 18446744073709551615)
                   )
                   (> log_size$ 0)
                  )
                  (= (Add log_size$ pmemlog!logimpl_v.contents_offset.?) (vstd!seq.Seq.len.? $ (UINT 8)
                    pm!
                 )))
                 (< (Sub tail$ head$) log_size$)
                )
                (=>
                 (= ib$ pmemlog!pmemspec_t.cdb0_val.?)
                 (and
                  (= (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc (%Poly%pmemlog!logimpl_v.PersistentHeader.
                     (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
                    )
                   ) (vstd!bytes.spec_u64_from_le_bytes.? (Poly%vstd!seq.Seq<u8.>. (pmemlog!pmemspec_t.spec_crc_bytes.?
                      (vstd!seq.Seq.subrange.? $ (UINT 8) pm! (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_head_offset.?))
                       (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_size.?))
                  )))))
                  (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) pm!
                    (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_crc_offset.?)) (
                     I (Add (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_crc_offset.?)
                      8
                    ))
                   ) (Poly%vstd!seq.Seq<u8.>. (pmemlog!pmemspec_t.spec_crc_bytes.? (vstd!seq.Seq.subrange.?
                      $ (UINT 8) pm! (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_head_offset.?))
                      (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_size.?))
               )))))))
               (=>
                (= ib$ pmemlog!pmemspec_t.cdb1_val.?)
                (and
                 (= (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc (%Poly%pmemlog!logimpl_v.PersistentHeader.
                    (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
                   )
                  ) (vstd!bytes.spec_u64_from_le_bytes.? (Poly%vstd!seq.Seq<u8.>. (pmemlog!pmemspec_t.spec_crc_bytes.?
                     (vstd!seq.Seq.subrange.? $ (UINT 8) pm! (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_head_offset.?))
                      (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_size.?))
                 )))))
                 (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) pm!
                   (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_crc_offset.?)) (
                    I (Add (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_crc_offset.?)
                     8
                   ))
                  ) (Poly%vstd!seq.Seq<u8.>. (pmemlog!pmemspec_t.spec_crc_bytes.? (vstd!seq.Seq.subrange.?
                     $ (UINT 8) pm! (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_head_offset.?))
                     (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_size.?))
              )))))))
              (<= head$ tail$)
    ))))))))))
    :pattern ((pmemlog!logimpl_v.impl&%0.log_state_is_valid.? pm!))
    :qid internal_pmemlog!logimpl_v.impl&__0.log_state_is_valid.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.impl&__0.log_state_is_valid.?_definition
))))

;; Function-Axioms pmemlog::logimpl_v::spec_addr_logical_to_physical
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.spec_addr_logical_to_physical.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.spec_addr_logical_to_physical.)
  (forall ((addr! Poly) (log_size! Poly)) (!
    (= (pmemlog!logimpl_v.spec_addr_logical_to_physical.? addr! log_size!) (Add (EucMod
       (%I addr!) (%I log_size!)
      ) pmemlog!logimpl_v.contents_offset.?
    ))
    :pattern ((pmemlog!logimpl_v.spec_addr_logical_to_physical.? addr! log_size!))
    :qid internal_pmemlog!logimpl_v.spec_addr_logical_to_physical.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.spec_addr_logical_to_physical.?_definition
))))

;; Function-Axioms pmemlog::logimpl_v::UntrustedLogImpl::recover
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.impl&%0.recover.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.impl&%0.recover.)
  (forall ((pm! Poly)) (!
    (= (pmemlog!logimpl_v.impl&%0.recover.? pm!) (let
      ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? pm!)))
      (let
       ((ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3.
              tmp%%$
        ))))))
        (let
         ((data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
         (ite
          (not (pmemlog!logimpl_v.impl&%0.log_state_is_valid.? pm!))
          core!option.Option./None
          (let
           ((live_header$ (ite
              (= ib$ pmemlog!pmemspec_t.cdb0_val.?)
              (pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
                (Poly%pmemlog!logimpl_v.HeaderView. headers$)
              ))
              (pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
                (Poly%pmemlog!logimpl_v.HeaderView. headers$)
           )))))
           (let
            ((head$ (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head (
                %Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                 (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                   (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
            )))))))
            (let
             ((tail$ (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail (
                 %Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                  (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                    (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
             )))))))
             (let
              ((log_size$ (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                 (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                   (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                     (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
              )))))))
              (let
               ((contents_end$ (Add log_size$ pmemlog!logimpl_v.contents_offset.?)))
               (let
                ((physical_head$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I head$) (I log_size$))))
                (let
                 ((physical_tail$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I tail$) (I log_size$))))
                 (let
                  ((abstract_log$ (%Poly%vstd!seq.Seq<u8.>. (ite
                      (< physical_head$ physical_tail$)
                      (vstd!seq.Seq.subrange.? $ (UINT 8) pm! (I physical_head$) (I physical_tail$))
                      (ite
                       (< physical_tail$ physical_head$)
                       (let
                        ((range1$ (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.subrange.? $ (UINT 8) pm! (I physical_head$)
                            (I contents_end$)
                        ))))
                        (let
                         ((range2$ (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.subrange.? $ (UINT 8) pm! (I pmemlog!logimpl_v.contents_offset.?)
                             (I physical_tail$)
                         ))))
                         (vstd!seq.Seq.add.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. range1$) (Poly%vstd!seq.Seq<u8.>.
                           range2$
                       ))))
                       (vstd!seq.Seq.empty.? $ (UINT 8))
                  )))))
                  (core!option.Option./Some (Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState
                     (%I (I head$)) (%Poly%vstd!seq.Seq<u8.>. (Poly%vstd!seq.Seq<u8.>. abstract_log$))
                     (%I (I (Sub log_size$ 1)))
    )))))))))))))))))
    :pattern ((pmemlog!logimpl_v.impl&%0.recover.? pm!))
    :qid internal_pmemlog!logimpl_v.impl&__0.recover.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.impl&__0.recover.?_definition
))))
(assert
 (forall ((pm! Poly)) (!
   (=>
    (has_type pm! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (has_type (Poly%core!option.Option. (pmemlog!logimpl_v.impl&%0.recover.? pm!)) (TYPE%core!option.Option.
      $ TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState.
   )))
   :pattern ((pmemlog!logimpl_v.impl&%0.recover.? pm!))
   :qid internal_pmemlog!logimpl_v.impl&__0.recover.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.impl&__0.recover.?_pre_post_definition
)))

;; Function-Axioms pmemlog::main_t::recovery_view
(assert
 (fuel_bool_default fuel%pmemlog!main_t.recovery_view.)
)
(declare-fun %%lambda%%2 () %%Function%%)
(assert
 (forall ((c$ Poly)) (!
   (= (%%apply%%0 %%lambda%%2 c$) (Poly%core!option.Option. (pmemlog!logimpl_v.impl&%0.recover.?
      c$
   )))
   :pattern ((%%apply%%0 %%lambda%%2 c$))
)))
(assert
 (=>
  (fuel_bool fuel%pmemlog!main_t.recovery_view.)
  (forall ((no%param Poly)) (!
    (= (pmemlog!main_t.recovery_view.? no%param) (mk_fun %%lambda%%2))
    :pattern ((pmemlog!main_t.recovery_view.? no%param))
    :qid internal_pmemlog!main_t.recovery_view.?_definition
    :skolemid skolem_internal_pmemlog!main_t.recovery_view.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%fun%1. (pmemlog!main_t.recovery_view.? no%param)) (TYPE%fun%1. $ (TYPE%vstd!seq.Seq.
       $ (UINT 8)
      ) $ (TYPE%core!option.Option. $ TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState.)
   )))
   :pattern ((pmemlog!main_t.recovery_view.? no%param))
   :qid internal_pmemlog!main_t.recovery_view.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!main_t.recovery_view.?_pre_post_definition
)))

;; Function-Axioms pmemlog::logimpl_v::permissions_depend_only_on_recovery_view
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.permissions_depend_only_on_recovery_view.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.permissions_depend_only_on_recovery_view.)
  (forall ((Perm&. Dcr) (Perm& Type) (perm! Poly)) (!
    (= (pmemlog!logimpl_v.permissions_depend_only_on_recovery_view.? Perm&. Perm& perm!)
     (forall ((s1$ Poly) (s2$ Poly)) (!
       (=>
        (and
         (has_type s1$ (TYPE%vstd!seq.Seq. $ (UINT 8)))
         (has_type s2$ (TYPE%vstd!seq.Seq. $ (UINT 8)))
        )
        (=>
         (= (%%apply%%0 (pmemlog!main_t.recovery_view.? (I 0)) s1$) (%%apply%%0 (pmemlog!main_t.recovery_view.?
            (I 0)
           ) s2$
         ))
         (= (pmemlog!sccf.CheckPermission.check_permission.? Perm&. Perm& $ (TYPE%vstd!seq.Seq.
            $ (UINT 8)
           ) perm! s1$
          ) (pmemlog!sccf.CheckPermission.check_permission.? Perm&. Perm& $ (TYPE%vstd!seq.Seq.
            $ (UINT 8)
           ) perm! s2$
       ))))
       :pattern ((pmemlog!sccf.CheckPermission.check_permission.? Perm&. Perm& $ (TYPE%vstd!seq.Seq.
          $ (UINT 8)
         ) perm! s1$
        ) (pmemlog!sccf.CheckPermission.check_permission.? Perm&. Perm& $ (TYPE%vstd!seq.Seq.
          $ (UINT 8)
         ) perm! s2$
       ))
       :qid user_pmemlog__logimpl_v__permissions_depend_only_on_recovery_view_33
       :skolemid skolem_user_pmemlog__logimpl_v__permissions_depend_only_on_recovery_view_33
    )))
    :pattern ((pmemlog!logimpl_v.permissions_depend_only_on_recovery_view.? Perm&. Perm&
      perm!
    ))
    :qid internal_pmemlog!logimpl_v.permissions_depend_only_on_recovery_view.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.permissions_depend_only_on_recovery_view.?_definition
))))

;; Function-Specs pmemlog::logimpl_v::spec_bytes_to_header
(declare-fun req%pmemlog!logimpl_v.spec_bytes_to_header. (Poly) Bool)
(declare-const %%global_location_label%%27 Bool)
(assert
 (forall ((header_seq! Poly)) (!
   (= (req%pmemlog!logimpl_v.spec_bytes_to_header. header_seq!) (=>
     %%global_location_label%%27
     (= (vstd!seq.Seq.len.? $ (UINT 8) header_seq!) pmemlog!logimpl_v.header_size.?)
   ))
   :pattern ((req%pmemlog!logimpl_v.spec_bytes_to_header. header_seq!))
   :qid internal_req__pmemlog!logimpl_v.spec_bytes_to_header._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.spec_bytes_to_header._definition
)))

;; Function-Axioms pmemlog::logimpl_v::spec_bytes_to_header
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.spec_bytes_to_header.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.spec_bytes_to_header.)
  (forall ((header_seq! Poly)) (!
    (= (pmemlog!logimpl_v.spec_bytes_to_header.? header_seq!) (let
      ((crc_val$ (vstd!bytes.spec_u64_from_le_bytes.? (vstd!seq.Seq.subrange.? $ (UINT 8) header_seq!
          (I pmemlog!logimpl_v.header_crc_offset.?) (I (Add pmemlog!logimpl_v.header_crc_offset.?
            8
      ))))))
      (let
       ((metadata$ (pmemlog!logimpl_v.spec_bytes_to_metadata.? (vstd!seq.Seq.subrange.? $ (UINT
            8
           ) header_seq! (I pmemlog!logimpl_v.header_head_offset.?) (I pmemlog!logimpl_v.header_size.?)
       ))))
       (pmemlog!logimpl_v.PersistentHeader./PersistentHeader (%I (I crc_val$)) (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
         (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. metadata$)
    )))))
    :pattern ((pmemlog!logimpl_v.spec_bytes_to_header.? header_seq!))
    :qid internal_pmemlog!logimpl_v.spec_bytes_to_header.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.spec_bytes_to_header.?_definition
))))
(assert
 (forall ((header_seq! Poly)) (!
   (=>
    (has_type header_seq! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (has_type (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.spec_bytes_to_header.?
       header_seq!
      )
     ) TYPE%pmemlog!logimpl_v.PersistentHeader.
   ))
   :pattern ((pmemlog!logimpl_v.spec_bytes_to_header.? header_seq!))
   :qid internal_pmemlog!logimpl_v.spec_bytes_to_header.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!logimpl_v.spec_bytes_to_header.?_pre_post_definition
)))

;; Function-Axioms pmemlog::logimpl_v::update_data_view_postcond
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.update_data_view_postcond.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.update_data_view_postcond.)
  (forall ((pm! Poly) (new_bytes! Poly) (write_addr! Poly)) (!
    (= (pmemlog!logimpl_v.update_data_view_postcond.? pm! new_bytes! write_addr!) (let
      ((new_pm$ (pmemlog!pmemspec_t.update_contents_to_reflect_write.? pm! write_addr! new_bytes!)))
      (let
       ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? pm!)))
       (let
        ((old_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
        (let
         ((old_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
              (Poly%tuple%3. tmp%%$)
         )))))
         (let
          ((old_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                tmp%%$
          ))))))
          (let
           ((tmp%%$1 (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. new_pm$))))
           (let
            ((new_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$1))))))
            (let
             ((new_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
                  (Poly%tuple%3. tmp%%$1)
             )))))
             (let
              ((new_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                    tmp%%$1
              ))))))
              (let
               ((live_header$ (pmemlog!logimpl_v.spec_get_live_header.? pm!)))
               (let
                ((physical_head$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head
                     (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                       (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                         (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
                    )))))
                   ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                     (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                       (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                         (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
                )))))))))
                (let
                 ((physical_tail$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail
                      (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                        (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                          (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
                     )))))
                    ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                      (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                        (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                          (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
                 )))))))))
                 (and
                  (and
                   (and
                    (and
                     (and
                      (and
                       (and
                        (and
                         (= old_ib$ new_ib$)
                         (= old_headers$ new_headers$)
                        )
                        (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_data$)) (vstd!seq.Seq.len.?
                          $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_data$)
                       )))
                       (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                          Poly%vstd!seq.Seq<u8.>. new_data$
                         ) (I (Sub (%I write_addr!) pmemlog!logimpl_v.contents_offset.?)) (I (Add (Sub (%I write_addr!)
                            pmemlog!logimpl_v.contents_offset.?
                           ) (vstd!seq.Seq.len.? $ (UINT 8) new_bytes!)
                         ))
                        ) new_bytes!
                      ))
                      (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                         Poly%vstd!seq.Seq<u8.>. new_data$
                        ) (I 0) (I (Sub (%I write_addr!) pmemlog!logimpl_v.contents_offset.?))
                       ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_data$) (I 0) (I
                         (Sub (%I write_addr!) pmemlog!logimpl_v.contents_offset.?)
                     ))))
                     (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                        Poly%vstd!seq.Seq<u8.>. new_data$
                       ) (I (Add (Sub (%I write_addr!) pmemlog!logimpl_v.contents_offset.?) (vstd!seq.Seq.len.?
                          $ (UINT 8) new_bytes!
                        ))
                       ) (I (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_data$)))
                      ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_data$) (I (Add (Sub
                          (%I write_addr!) pmemlog!logimpl_v.contents_offset.?
                         ) (vstd!seq.Seq.len.? $ (UINT 8) new_bytes!)
                        )
                       ) (I (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_data$)))
                    )))
                    (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
                       new_pm$
                   ))))
                   (=>
                    (< physical_head$ physical_tail$)
                    (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                       Poly%vstd!seq.Seq<u8.>. new_data$
                      ) (I (Sub physical_head$ pmemlog!logimpl_v.contents_offset.?)) (I (Sub physical_tail$
                        pmemlog!logimpl_v.contents_offset.?
                      ))
                     ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_data$) (I (Sub physical_head$
                        pmemlog!logimpl_v.contents_offset.?
                       )
                      ) (I (Sub physical_tail$ pmemlog!logimpl_v.contents_offset.?))
                  ))))
                  (=>
                   (< physical_tail$ physical_head$)
                   (and
                    (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                       Poly%vstd!seq.Seq<u8.>. old_data$
                      ) (I (Sub physical_head$ pmemlog!logimpl_v.contents_offset.?)) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                        (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                          (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                            (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
                      ))))))
                     ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_data$) (I (Sub physical_head$
                        pmemlog!logimpl_v.contents_offset.?
                       )
                      ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                        (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                          (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                            (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
                    ))))))))
                    (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                       Poly%vstd!seq.Seq<u8.>. old_data$
                      ) (I 0) (I (Sub physical_tail$ pmemlog!logimpl_v.contents_offset.?))
                     ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_data$) (I 0) (I
                       (Sub physical_tail$ pmemlog!logimpl_v.contents_offset.?)
    )))))))))))))))))))
    :pattern ((pmemlog!logimpl_v.update_data_view_postcond.? pm! new_bytes! write_addr!))
    :qid internal_pmemlog!logimpl_v.update_data_view_postcond.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.update_data_view_postcond.?_definition
))))

;; Function-Axioms pmemlog::logimpl_v::live_data_view_eq
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.live_data_view_eq.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.live_data_view_eq.)
  (forall ((old_pm! Poly) (new_pm! Poly)) (!
    (= (pmemlog!logimpl_v.live_data_view_eq.? old_pm! new_pm!) (let
      ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? old_pm!)))
      (let
       ((old_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((old_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
             (Poly%tuple%3. tmp%%$)
        )))))
        (let
         ((old_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
               tmp%%$
         ))))))
         (let
          ((tmp%%$1 (pmemlog!logimpl_v.pm_to_views.? new_pm!)))
          (let
           ((new_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$1))))))
           (let
            ((new_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
                 (Poly%tuple%3. tmp%%$1)
            )))))
            (let
             ((new_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                   tmp%%$1
             ))))))
             (let
              ((old_live_header$ (pmemlog!logimpl_v.spec_get_live_header.? old_pm!)))
              (let
               ((new_live_header$ (pmemlog!logimpl_v.spec_get_live_header.? new_pm!)))
               (let
                ((physical_head$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head
                     (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                       (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                         (Poly%pmemlog!logimpl_v.PersistentHeader. old_live_header$)
                    )))))
                   ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                     (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                       (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                         (Poly%pmemlog!logimpl_v.PersistentHeader. old_live_header$)
                )))))))))
                (let
                 ((physical_tail$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail
                      (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                        (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                          (Poly%pmemlog!logimpl_v.PersistentHeader. old_live_header$)
                     )))))
                    ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                      (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                        (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                          (Poly%pmemlog!logimpl_v.PersistentHeader. old_live_header$)
                 )))))))))
                 (let
                  ((log_size$ (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                     (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                       (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                         (Poly%pmemlog!logimpl_v.PersistentHeader. old_live_header$)
                  )))))))
                  (let
                   ((physical_data_head$ (Sub physical_head$ pmemlog!logimpl_v.contents_offset.?)))
                   (let
                    ((physical_data_tail$ (Sub physical_tail$ pmemlog!logimpl_v.contents_offset.?)))
                    (and
                     (and
                      (and
                       (= new_live_header$ old_live_header$)
                       (=>
                        (< physical_head$ physical_tail$)
                        (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                           Poly%vstd!seq.Seq<u8.>. old_data$
                          ) (I physical_data_head$) (I physical_data_tail$)
                         ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_data$) (I physical_data_head$)
                          (I physical_data_tail$)
                      ))))
                      (=>
                       (< physical_tail$ physical_head$)
                       (and
                        (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                           Poly%vstd!seq.Seq<u8.>. old_data$
                          ) (I physical_data_head$) (I log_size$)
                         ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_data$) (I physical_data_head$)
                          (I log_size$)
                        ))
                        (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                           Poly%vstd!seq.Seq<u8.>. old_data$
                          ) (I 0) (I physical_data_tail$)
                         ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_data$) (I 0) (I
                           physical_data_tail$
                     ))))))
                     (=>
                      (= physical_tail$ physical_head$)
                      (= physical_data_head$ physical_data_tail$)
    ))))))))))))))))))
    :pattern ((pmemlog!logimpl_v.live_data_view_eq.? old_pm! new_pm!))
    :qid internal_pmemlog!logimpl_v.live_data_view_eq.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.live_data_view_eq.?_definition
))))

;; Function-Axioms pmemlog::logimpl_v::UntrustedLogImpl::inv_pm_contents
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.impl&%0.inv_pm_contents.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.impl&%0.inv_pm_contents.)
  (forall ((self! Poly) (contents! Poly)) (!
    (= (pmemlog!logimpl_v.impl&%0.inv_pm_contents.? self! contents!) (let
      ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? contents!)))
      (let
       ((ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3.
              tmp%%$
        ))))))
        (let
         ((data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
         (let
          ((header_pos$ (ite
             (= ib$ pmemlog!pmemspec_t.cdb0_val.?)
             pmemlog!logimpl_v.header1_pos.?
             pmemlog!logimpl_v.header2_pos.?
          )))
          (let
           ((header$ (pmemlog!logimpl_v.spec_get_live_header.? contents!)))
           (let
            ((head$ (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head (
                %Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                 (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                   (Poly%pmemlog!logimpl_v.PersistentHeader. header$)
            )))))))
            (let
             ((tail$ (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail (
                 %Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                  (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                    (Poly%pmemlog!logimpl_v.PersistentHeader. header$)
             )))))))
             (let
              ((log_size$ (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                 (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                   (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                     (Poly%pmemlog!logimpl_v.PersistentHeader. header$)
              )))))))
              (and
               (and
                (and
                 (and
                  (and
                   (and
                    (and
                     (and
                      (and
                       (and
                        (or
                         (= ib$ pmemlog!pmemspec_t.cdb0_val.?)
                         (= ib$ pmemlog!pmemspec_t.cdb1_val.?)
                        )
                        (= (pmemlog!pmemspec_t.spec_crc_bytes.? (vstd!seq.Seq.subrange.? $ (UINT 8) contents!
                           (I (Add header_pos$ pmemlog!logimpl_v.header_head_offset.?)) (I (Add header_pos$ pmemlog!logimpl_v.header_size.?))
                          )
                         ) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.subrange.? $ (UINT 8) contents! (I (Add header_pos$
                             pmemlog!logimpl_v.header_crc_offset.?
                            )
                           ) (I (Add (Add header_pos$ pmemlog!logimpl_v.header_crc_offset.?) 8))
                       ))))
                       (<= (Add log_size$ pmemlog!logimpl_v.contents_offset.?) 18446744073709551615)
                      )
                      (< (Sub tail$ head$) log_size$)
                     )
                     (= (Add log_size$ pmemlog!logimpl_v.contents_offset.?) (vstd!seq.Seq.len.? $ (UINT 8)
                       contents!
                    )))
                    (= (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/header_crc (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
                       self!
                      )
                     ) (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc (%Poly%pmemlog!logimpl_v.PersistentHeader.
                       (Poly%pmemlog!logimpl_v.PersistentHeader. header$)
                   ))))
                   (= (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/head (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
                      self!
                     )
                    ) head$
                  ))
                  (= (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/tail (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
                     self!
                    )
                   ) tail$
                 ))
                 (= (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/log_size (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
                    self!
                   )
                  ) log_size$
                ))
                (= (pmemlog!logimpl_v.UntrustedLogImpl./UntrustedLogImpl/incorruptible_bool (%Poly%pmemlog!logimpl_v.UntrustedLogImpl.
                   self!
                  )
                 ) ib$
               ))
               (let
                ((tmp%%$1 (pmemlog!logimpl_v.impl&%0.recover.? contents!)))
                (and
                 (is-core!option.Option./Some tmp%%$1)
                 (let
                  ((inf_log$ (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. (core!option.Option./Some/0
                      $ TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState. (%Poly%core!option.Option.
                       (Poly%core!option.Option. tmp%%$1)
                  )))))
                  (= tail$ (Add head$ (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. (pmemlog!infinitelog_t.AbstractInfiniteLogState./AbstractInfiniteLogState/log
                       (%Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState. (Poly%pmemlog!infinitelog_t.AbstractInfiniteLogState.
                         inf_log$
    )))))))))))))))))))))
    :pattern ((pmemlog!logimpl_v.impl&%0.inv_pm_contents.? self! contents!))
    :qid internal_pmemlog!logimpl_v.impl&__0.inv_pm_contents.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.impl&__0.inv_pm_contents.?_definition
))))

;; Function-Axioms pmemlog::logimpl_v::UntrustedLogImpl::inv
(assert
 (fuel_bool_default fuel%pmemlog!logimpl_v.impl&%0.inv.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!logimpl_v.impl&%0.inv.)
  (forall ((Perm&. Dcr) (Perm& Type) (PM&. Dcr) (PM& Type) (self! Poly) (wrpm! Poly))
   (!
    (= (pmemlog!logimpl_v.impl&%0.inv.? Perm&. Perm& PM&. PM& self! wrpm!) (and
      (pmemlog!pmemspec_t.impl&%0.inv.? Perm&. Perm& PM&. PM& wrpm!)
      (pmemlog!logimpl_v.impl&%0.inv_pm_contents.? self! (Poly%vstd!seq.Seq<u8.>. (pmemlog!pmemspec_t.impl&%0.view.?
         Perm&. Perm& PM&. PM& wrpm!
    )))))
    :pattern ((pmemlog!logimpl_v.impl&%0.inv.? Perm&. Perm& PM&. PM& self! wrpm!))
    :qid internal_pmemlog!logimpl_v.impl&__0.inv.?_definition
    :skolemid skolem_internal_pmemlog!logimpl_v.impl&__0.inv.?_definition
))))

;; Function-Axioms pmemlog::main_t::read_correct_modulo_corruption
(assert
 (fuel_bool_default fuel%pmemlog!main_t.read_correct_modulo_corruption.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!main_t.read_correct_modulo_corruption.)
  (forall ((bytes! Poly) (true_bytes! Poly) (impervious_to_corruption! Poly)) (!
    (= (pmemlog!main_t.read_correct_modulo_corruption.? bytes! true_bytes! impervious_to_corruption!)
     (ite
      (%B impervious_to_corruption!)
      (= bytes! true_bytes!)
      (exists ((addrs$ Poly)) (!
        (and
         (has_type addrs$ (TYPE%vstd!seq.Seq. $ INT))
         (and
          (pmemlog!pmemspec_t.all_elements_unique.? addrs$)
          (pmemlog!pmemspec_t.maybe_corrupted.? bytes! true_bytes! addrs$)
        ))
        :pattern ((pmemlog!pmemspec_t.maybe_corrupted.? bytes! true_bytes! addrs$))
        :qid user_pmemlog__main_t__read_correct_modulo_corruption_34
        :skolemid skolem_user_pmemlog__main_t__read_correct_modulo_corruption_34
    ))))
    :pattern ((pmemlog!main_t.read_correct_modulo_corruption.? bytes! true_bytes! impervious_to_corruption!))
    :qid internal_pmemlog!main_t.read_correct_modulo_corruption.?_definition
    :skolemid skolem_internal_pmemlog!main_t.read_correct_modulo_corruption.?_definition
))))

;; Function-Axioms pmemlog::pmemspec_t::persistence_chunk_size
(assert
 (fuel_bool_default fuel%pmemlog!pmemspec_t.persistence_chunk_size.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!pmemspec_t.persistence_chunk_size.)
  (= pmemlog!pmemspec_t.persistence_chunk_size.? 8)
))

;; Function-Axioms pmemlog::pmemspec_t::update_byte_to_reflect_partially_flushed_write
(assert
 (fuel_bool_default fuel%pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.)
)
(assert
 (=>
  (fuel_bool fuel%pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.)
  (forall ((addr! Poly) (prewrite_byte! Poly) (write_addr! Poly) (write_bytes! Poly)
    (chunks_flushed! Poly)
   ) (!
    (= (pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.? addr! prewrite_byte!
      write_addr! write_bytes! chunks_flushed!
     ) (ite
      (vstd!set.Set.contains.? $ INT chunks_flushed! (I (EucDiv (%I addr!) pmemlog!pmemspec_t.persistence_chunk_size.?)))
      (pmemlog!pmemspec_t.update_byte_to_reflect_write.? addr! prewrite_byte! write_addr!
       write_bytes!
      )
      (%I prewrite_byte!)
    ))
    :pattern ((pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.? addr!
      prewrite_byte! write_addr! write_bytes! chunks_flushed!
    ))
    :qid internal_pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.?_definition
    :skolemid skolem_internal_pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.?_definition
))))
(assert
 (forall ((addr! Poly) (prewrite_byte! Poly) (write_addr! Poly) (write_bytes! Poly)
   (chunks_flushed! Poly)
  ) (!
   (=>
    (and
     (has_type addr! INT)
     (has_type prewrite_byte! (UINT 8))
     (has_type write_addr! INT)
     (has_type write_bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type chunks_flushed! (TYPE%vstd!set.Set. $ INT))
    )
    (uInv 8 (pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.? addr!
      prewrite_byte! write_addr! write_bytes! chunks_flushed!
   )))
   :pattern ((pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.? addr!
     prewrite_byte! write_addr! write_bytes! chunks_flushed!
   ))
   :qid internal_pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.?_pre_post_definition
   :skolemid skolem_internal_pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.?_pre_post_definition
)))

;; Function-Specs pmemlog::pmemspec_t::update_contents_to_reflect_partially_flushed_write
(declare-fun req%pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.
 (Poly Poly Poly Poly) Bool
)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((contents! Poly) (write_addr! Poly) (write_bytes! Poly) (chunks_flushed! Poly))
  (!
   (= (req%pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write. contents!
     write_addr! write_bytes! chunks_flushed!
    ) (and
     (=>
      %%global_location_label%%28
      (<= 0 (%I write_addr!))
     )
     (=>
      %%global_location_label%%29
      (<= (Add (%I write_addr!) (vstd!seq.Seq.len.? $ (UINT 8) write_bytes!)) (vstd!seq.Seq.len.?
        $ (UINT 8) contents!
   )))))
   :pattern ((req%pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.
     contents! write_addr! write_bytes! chunks_flushed!
   ))
   :qid internal_req__pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write._definition
   :skolemid skolem_internal_req__pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write._definition
)))

;; Function-Axioms pmemlog::pmemspec_t::update_contents_to_reflect_partially_flushed_write
(assert
 (fuel_bool_default fuel%pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.)
)
(declare-fun %%lambda%%3 (Dcr Type Poly Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   ) (%%hole%%5 Poly) (addr$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%3 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5)
     addr$
    ) (I (pmemlog!pmemspec_t.update_byte_to_reflect_partially_flushed_write.? addr$ (vstd!seq.Seq.index.?
       %%hole%%0 %%hole%%1 %%hole%%2 addr$
      ) %%hole%%3 %%hole%%4 %%hole%%5
   )))
   :pattern ((%%apply%%0 (%%lambda%%3 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4
      %%hole%%5
     ) addr$
)))))
(assert
 (=>
  (fuel_bool fuel%pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.)
  (forall ((contents! Poly) (write_addr! Poly) (write_bytes! Poly) (chunks_flushed! Poly))
   (!
    (= (pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.? contents!
      write_addr! write_bytes! chunks_flushed!
     ) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.new.? $ (UINT 8) $ (TYPE%fun%1. $ INT $ (UINT
         8
        )
       ) (I (vstd!seq.Seq.len.? $ (UINT 8) contents!)) (Poly%fun%1. (mk_fun (%%lambda%%3 $
          (UINT 8) contents! write_addr! write_bytes! chunks_flushed!
    ))))))
    :pattern ((pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.?
      contents! write_addr! write_bytes! chunks_flushed!
    ))
    :qid internal_pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.?_definition
    :skolemid skolem_internal_pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (REF A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (REF A&.) A&))
   :qid internal_vstd__view__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__6_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!view.View. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_vstd__view__impl&__10_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__10_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
    )
    (tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_vstd__view__impl&__44_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__44_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (sized A2&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
     (tr_bound%vstd!view.View. A2&. A2&)
    )
    (tr_bound%vstd!view.View. (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&.
      A2&
   )))
   :qid internal_vstd__view__impl&__46_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__46_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%core!alloc.Allocator. A&. A&)
    (tr_bound%core!alloc.Allocator. (REF A&.) A&)
   )
   :pattern ((tr_bound%core!alloc.Allocator. (REF A&.) A&))
   :qid internal_core__alloc__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__alloc__impl&__2_trait_impl_definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_same_permissions
(declare-fun req%pmemlog!logimpl_v.lemma_same_permissions. (Dcr Type vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. Poly
 ) Bool
)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(declare-const %%global_location_label%%32 Bool)
(assert
 (forall ((Perm&. Dcr) (Perm& Type) (pm1! vstd!seq.Seq<u8.>.) (pm2! vstd!seq.Seq<u8.>.)
   (perm! Poly)
  ) (!
   (= (req%pmemlog!logimpl_v.lemma_same_permissions. Perm&. Perm& pm1! pm2! perm!) (and
     (=>
      %%global_location_label%%30
      (ext_eq false (TYPE%core!option.Option. $ TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState.)
       (%%apply%%0 (pmemlog!main_t.recovery_view.? (I 0)) (Poly%vstd!seq.Seq<u8.>. pm1!))
       (%%apply%%0 (pmemlog!main_t.recovery_view.? (I 0)) (Poly%vstd!seq.Seq<u8.>. pm2!))
     ))
     (=>
      %%global_location_label%%31
      (%B (pmemlog!sccf.CheckPermission.check_permission.? Perm&. Perm& $ (TYPE%vstd!seq.Seq.
         $ (UINT 8)
        ) perm! (Poly%vstd!seq.Seq<u8.>. pm1!)
     )))
     (=>
      %%global_location_label%%32
      (pmemlog!logimpl_v.permissions_depend_only_on_recovery_view.? Perm&. Perm& perm!)
   )))
   :pattern ((req%pmemlog!logimpl_v.lemma_same_permissions. Perm&. Perm& pm1! pm2! perm!))
   :qid internal_req__pmemlog!logimpl_v.lemma_same_permissions._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_same_permissions._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_same_permissions. (Dcr Type vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. Poly
 ) Bool
)
(assert
 (forall ((Perm&. Dcr) (Perm& Type) (pm1! vstd!seq.Seq<u8.>.) (pm2! vstd!seq.Seq<u8.>.)
   (perm! Poly)
  ) (!
   (= (ens%pmemlog!logimpl_v.lemma_same_permissions. Perm&. Perm& pm1! pm2! perm!) (%B
     (pmemlog!sccf.CheckPermission.check_permission.? Perm&. Perm& $ (TYPE%vstd!seq.Seq.
       $ (UINT 8)
      ) perm! (Poly%vstd!seq.Seq<u8.>. pm2!)
   )))
   :pattern ((ens%pmemlog!logimpl_v.lemma_same_permissions. Perm&. Perm& pm1! pm2! perm!))
   :qid internal_ens__pmemlog!logimpl_v.lemma_same_permissions._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_same_permissions._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_seq_addition
(declare-fun ens%pmemlog!logimpl_v.lemma_seq_addition. (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.)
 Bool
)
(assert
 (forall ((bytes1! vstd!seq.Seq<u8.>.) (bytes2! vstd!seq.Seq<u8.>.)) (!
   (= (ens%pmemlog!logimpl_v.lemma_seq_addition. bytes1! bytes2!) (let
     ((i$ (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes1!))))
     (let
      ((j$ (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes2!))))
      (and
       (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
          vstd!seq.Seq.add.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes1!) (Poly%vstd!seq.Seq<u8.>.
           bytes2!
          )
         ) (I 0) (I i$)
        ) (Poly%vstd!seq.Seq<u8.>. bytes1!)
       )
       (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
          vstd!seq.Seq.add.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes1!) (Poly%vstd!seq.Seq<u8.>.
           bytes2!
          )
         ) (I i$) (I (Add i$ j$))
        ) (Poly%vstd!seq.Seq<u8.>. bytes2!)
   )))))
   :pattern ((ens%pmemlog!logimpl_v.lemma_seq_addition. bytes1! bytes2!))
   :qid internal_ens__pmemlog!logimpl_v.lemma_seq_addition._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_seq_addition._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_bytes_combine_into_header
(declare-fun req%pmemlog!logimpl_v.lemma_bytes_combine_into_header. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. pmemlog!logimpl_v.PersistentHeader.
 ) Bool
)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(assert
 (forall ((crc_bytes! vstd!seq.Seq<u8.>.) (metadata_bytes! vstd!seq.Seq<u8.>.) (header!
    pmemlog!logimpl_v.PersistentHeader.
   )
  ) (!
   (= (req%pmemlog!logimpl_v.lemma_bytes_combine_into_header. crc_bytes! metadata_bytes!
     header!
    ) (and
     (=>
      %%global_location_label%%33
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. crc_bytes!)) 8)
     )
     (=>
      %%global_location_label%%34
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. metadata_bytes!)) (Sub pmemlog!logimpl_v.header_size.?
        8
     )))
     (=>
      %%global_location_label%%35
      (= (pmemlog!logimpl_v.spec_bytes_to_header.? (vstd!seq.Seq.add.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
          crc_bytes!
         ) (Poly%vstd!seq.Seq<u8.>. metadata_bytes!)
        )
       ) header!
   ))))
   :pattern ((req%pmemlog!logimpl_v.lemma_bytes_combine_into_header. crc_bytes! metadata_bytes!
     header!
   ))
   :qid internal_req__pmemlog!logimpl_v.lemma_bytes_combine_into_header._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_bytes_combine_into_header._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_bytes_combine_into_header. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. pmemlog!logimpl_v.PersistentHeader.
 ) Bool
)
(assert
 (forall ((crc_bytes! vstd!seq.Seq<u8.>.) (metadata_bytes! vstd!seq.Seq<u8.>.) (header!
    pmemlog!logimpl_v.PersistentHeader.
   )
  ) (!
   (= (ens%pmemlog!logimpl_v.lemma_bytes_combine_into_header. crc_bytes! metadata_bytes!
     header!
    ) (let
     ((combined_header$ (pmemlog!logimpl_v.PersistentHeader./PersistentHeader (%I (I (vstd!bytes.spec_u64_from_le_bytes.?
           (Poly%vstd!seq.Seq<u8.>. crc_bytes!)
         ))
        ) (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
          (pmemlog!logimpl_v.spec_bytes_to_metadata.? (Poly%vstd!seq.Seq<u8.>. metadata_bytes!))
     )))))
     (= header! combined_header$)
   ))
   :pattern ((ens%pmemlog!logimpl_v.lemma_bytes_combine_into_header. crc_bytes! metadata_bytes!
     header!
   ))
   :qid internal_ens__pmemlog!logimpl_v.lemma_bytes_combine_into_header._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_bytes_combine_into_header._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_header_match
(declare-fun req%pmemlog!logimpl_v.lemma_header_match. (vstd!seq.Seq<u8.>. Int pmemlog!logimpl_v.PersistentHeader.)
 Bool
)
(declare-const %%global_location_label%%36 Bool)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(assert
 (forall ((pm! vstd!seq.Seq<u8.>.) (header_pos! Int) (header! pmemlog!logimpl_v.PersistentHeader.))
  (!
   (= (req%pmemlog!logimpl_v.lemma_header_match. pm! header_pos! header!) (and
     (=>
      %%global_location_label%%36
      (> (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. pm!)) pmemlog!logimpl_v.contents_offset.?)
     )
     (=>
      %%global_location_label%%37
      (or
       (= header_pos! pmemlog!logimpl_v.header1_pos.?)
       (= header_pos! pmemlog!logimpl_v.header2_pos.?)
     ))
     (=>
      %%global_location_label%%38
      (= (pmemlog!logimpl_v.spec_bytes_to_header.? (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
          pm!
         ) (I header_pos!) (I (Add header_pos! pmemlog!logimpl_v.header_size.?))
        )
       ) header!
   ))))
   :pattern ((req%pmemlog!logimpl_v.lemma_header_match. pm! header_pos! header!))
   :qid internal_req__pmemlog!logimpl_v.lemma_header_match._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_header_match._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_header_match. (vstd!seq.Seq<u8.>. Int pmemlog!logimpl_v.PersistentHeader.)
 Bool
)
(assert
 (forall ((pm! vstd!seq.Seq<u8.>.) (header_pos! Int) (header! pmemlog!logimpl_v.PersistentHeader.))
  (!
   (= (ens%pmemlog!logimpl_v.lemma_header_match. pm! header_pos! header!) (let
     ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. pm!))))
     (let
      ((headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3.
            tmp%%$
      ))))))
      (and
       (=>
        (= header_pos! pmemlog!logimpl_v.header1_pos.?)
        (= (pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
           (Poly%pmemlog!logimpl_v.HeaderView. headers$)
          )
         ) header!
       ))
       (=>
        (= header_pos! pmemlog!logimpl_v.header2_pos.?)
        (= (pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
           (Poly%pmemlog!logimpl_v.HeaderView. headers$)
          )
         ) header!
   ))))))
   :pattern ((ens%pmemlog!logimpl_v.lemma_header_match. pm! header_pos! header!))
   :qid internal_ens__pmemlog!logimpl_v.lemma_header_match._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_header_match._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_metadata_bytes_eq
(declare-fun req%pmemlog!logimpl_v.lemma_metadata_bytes_eq. (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.
  pmemlog!logimpl_v.PersistentHeaderMetadata.
 ) Bool
)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(declare-const %%global_location_label%%41 Bool)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((bytes1! vstd!seq.Seq<u8.>.) (bytes2! vstd!seq.Seq<u8.>.) (metadata! pmemlog!logimpl_v.PersistentHeaderMetadata.))
  (!
   (= (req%pmemlog!logimpl_v.lemma_metadata_bytes_eq. bytes1! bytes2! metadata!) (and
     (=>
      %%global_location_label%%39
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes1!)) (Sub pmemlog!logimpl_v.header_size.?
        8
     )))
     (=>
      %%global_location_label%%40
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes2!)) (Sub pmemlog!logimpl_v.header_size.?
        8
     )))
     (=>
      %%global_location_label%%41
      (= metadata! (pmemlog!logimpl_v.spec_bytes_to_metadata.? (Poly%vstd!seq.Seq<u8.>. bytes1!)))
     )
     (=>
      %%global_location_label%%42
      (= metadata! (pmemlog!logimpl_v.spec_bytes_to_metadata.? (Poly%vstd!seq.Seq<u8.>. bytes2!)))
   )))
   :pattern ((req%pmemlog!logimpl_v.lemma_metadata_bytes_eq. bytes1! bytes2! metadata!))
   :qid internal_req__pmemlog!logimpl_v.lemma_metadata_bytes_eq._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_metadata_bytes_eq._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_metadata_bytes_eq. (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.
  pmemlog!logimpl_v.PersistentHeaderMetadata.
 ) Bool
)
(assert
 (forall ((bytes1! vstd!seq.Seq<u8.>.) (bytes2! vstd!seq.Seq<u8.>.) (metadata! pmemlog!logimpl_v.PersistentHeaderMetadata.))
  (!
   (= (ens%pmemlog!logimpl_v.lemma_metadata_bytes_eq. bytes1! bytes2! metadata!) (ext_eq
     false (TYPE%vstd!seq.Seq. $ (UINT 8)) (Poly%vstd!seq.Seq<u8.>. bytes1!) (Poly%vstd!seq.Seq<u8.>.
      bytes2!
   )))
   :pattern ((ens%pmemlog!logimpl_v.lemma_metadata_bytes_eq. bytes1! bytes2! metadata!))
   :qid internal_ens__pmemlog!logimpl_v.lemma_metadata_bytes_eq._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_metadata_bytes_eq._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_header_split_into_bytes
(declare-fun req%pmemlog!logimpl_v.lemma_header_split_into_bytes. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.
 ) Bool
)
(declare-const %%global_location_label%%43 Bool)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(assert
 (forall ((crc_bytes! vstd!seq.Seq<u8.>.) (metadata_bytes! vstd!seq.Seq<u8.>.) (header_bytes!
    vstd!seq.Seq<u8.>.
   )
  ) (!
   (= (req%pmemlog!logimpl_v.lemma_header_split_into_bytes. crc_bytes! metadata_bytes!
     header_bytes!
    ) (and
     (=>
      %%global_location_label%%43
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. crc_bytes!)) 8)
     )
     (=>
      %%global_location_label%%44
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. metadata_bytes!)) (Sub pmemlog!logimpl_v.header_size.?
        8
     )))
     (=>
      %%global_location_label%%45
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. header_bytes!)) pmemlog!logimpl_v.header_size.?)
     )
     (=>
      %%global_location_label%%46
      (let
       ((header$ (pmemlog!logimpl_v.PersistentHeader./PersistentHeader (%I (I (vstd!bytes.spec_u64_from_le_bytes.?
             (Poly%vstd!seq.Seq<u8.>. crc_bytes!)
           ))
          ) (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
            (pmemlog!logimpl_v.spec_bytes_to_metadata.? (Poly%vstd!seq.Seq<u8.>. metadata_bytes!))
       )))))
       (= (pmemlog!logimpl_v.spec_bytes_to_header.? (Poly%vstd!seq.Seq<u8.>. header_bytes!))
        header$
   )))))
   :pattern ((req%pmemlog!logimpl_v.lemma_header_split_into_bytes. crc_bytes! metadata_bytes!
     header_bytes!
   ))
   :qid internal_req__pmemlog!logimpl_v.lemma_header_split_into_bytes._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_header_split_into_bytes._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_header_split_into_bytes. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.
 ) Bool
)
(assert
 (forall ((crc_bytes! vstd!seq.Seq<u8.>.) (metadata_bytes! vstd!seq.Seq<u8.>.) (header_bytes!
    vstd!seq.Seq<u8.>.
   )
  ) (!
   (= (ens%pmemlog!logimpl_v.lemma_header_split_into_bytes. crc_bytes! metadata_bytes!
     header_bytes!
    ) (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.add.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
       crc_bytes!
      ) (Poly%vstd!seq.Seq<u8.>. metadata_bytes!)
     ) (Poly%vstd!seq.Seq<u8.>. header_bytes!)
   ))
   :pattern ((ens%pmemlog!logimpl_v.lemma_header_split_into_bytes. crc_bytes! metadata_bytes!
     header_bytes!
   ))
   :qid internal_ens__pmemlog!logimpl_v.lemma_header_split_into_bytes._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_header_split_into_bytes._definition
)))

;; Function-Specs pmemlog::logimpl_v::bytes_to_metadata
(declare-fun req%pmemlog!logimpl_v.bytes_to_metadata. (slice%<u8.>.) Bool)
(declare-const %%global_location_label%%47 Bool)
(assert
 (forall ((bytes! slice%<u8.>.)) (!
   (= (req%pmemlog!logimpl_v.bytes_to_metadata. bytes!) (=>
     %%global_location_label%%47
     (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) (
         Poly%slice%<u8.>. bytes!
       ))
      ) (Sub pmemlog!logimpl_v.header_size.? 8)
   )))
   :pattern ((req%pmemlog!logimpl_v.bytes_to_metadata. bytes!))
   :qid internal_req__pmemlog!logimpl_v.bytes_to_metadata._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.bytes_to_metadata._definition
)))
(declare-fun ens%pmemlog!logimpl_v.bytes_to_metadata. (slice%<u8.>. pmemlog!logimpl_v.PersistentHeaderMetadata.)
 Bool
)
(assert
 (forall ((bytes! slice%<u8.>.) (out! pmemlog!logimpl_v.PersistentHeaderMetadata.))
  (!
   (= (ens%pmemlog!logimpl_v.bytes_to_metadata. bytes! out!) (and
     (has_type (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. out!) TYPE%pmemlog!logimpl_v.PersistentHeaderMetadata.)
     (= out! (pmemlog!logimpl_v.spec_bytes_to_metadata.? (vstd!view.View.view.? $slice (SLICE
         $ (UINT 8)
        ) (Poly%slice%<u8.>. bytes!)
   )))))
   :pattern ((ens%pmemlog!logimpl_v.bytes_to_metadata. bytes! out!))
   :qid internal_ens__pmemlog!logimpl_v.bytes_to_metadata._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.bytes_to_metadata._definition
)))

;; Function-Specs pmemlog::logimpl_v::bytes_to_header
(declare-fun req%pmemlog!logimpl_v.bytes_to_header. (slice%<u8.>.) Bool)
(declare-const %%global_location_label%%48 Bool)
(assert
 (forall ((bytes! slice%<u8.>.)) (!
   (= (req%pmemlog!logimpl_v.bytes_to_header. bytes!) (=>
     %%global_location_label%%48
     (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) (
         Poly%slice%<u8.>. bytes!
       ))
      ) pmemlog!logimpl_v.header_size.?
   )))
   :pattern ((req%pmemlog!logimpl_v.bytes_to_header. bytes!))
   :qid internal_req__pmemlog!logimpl_v.bytes_to_header._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.bytes_to_header._definition
)))
(declare-fun ens%pmemlog!logimpl_v.bytes_to_header. (slice%<u8.>. pmemlog!logimpl_v.PersistentHeader.)
 Bool
)
(assert
 (forall ((bytes! slice%<u8.>.) (out! pmemlog!logimpl_v.PersistentHeader.)) (!
   (= (ens%pmemlog!logimpl_v.bytes_to_header. bytes! out!) (and
     (has_type (Poly%pmemlog!logimpl_v.PersistentHeader. out!) TYPE%pmemlog!logimpl_v.PersistentHeader.)
     (= out! (pmemlog!logimpl_v.spec_bytes_to_header.? (vstd!view.View.view.? $slice (SLICE
         $ (UINT 8)
        ) (Poly%slice%<u8.>. bytes!)
   )))))
   :pattern ((ens%pmemlog!logimpl_v.bytes_to_header. bytes! out!))
   :qid internal_ens__pmemlog!logimpl_v.bytes_to_header._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.bytes_to_header._definition
)))

;; Function-Specs pmemlog::logimpl_v::metadata_to_bytes
(declare-fun ens%pmemlog!logimpl_v.metadata_to_bytes. (pmemlog!logimpl_v.PersistentHeaderMetadata.
  alloc!vec.Vec<u8./allocator_global%.>.
 ) Bool
)
(assert
 (forall ((metadata! pmemlog!logimpl_v.PersistentHeaderMetadata.) (out! alloc!vec.Vec<u8./allocator_global%.>.))
  (!
   (= (ens%pmemlog!logimpl_v.metadata_to_bytes. metadata! out!) (and
     (= metadata! (pmemlog!logimpl_v.spec_bytes_to_metadata.? (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
         $ (UINT 8) $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<u8./allocator_global%.>. out!)
     )))
     (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (UINT
          8
         ) $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<u8./allocator_global%.>. out!)
       )
      ) (Sub pmemlog!logimpl_v.header_size.? 8)
   )))
   :pattern ((ens%pmemlog!logimpl_v.metadata_to_bytes. metadata! out!))
   :qid internal_ens__pmemlog!logimpl_v.metadata_to_bytes._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.metadata_to_bytes._definition
)))

;; Function-Specs pmemlog::logimpl_v::header_to_bytes
(declare-fun ens%pmemlog!logimpl_v.header_to_bytes. (pmemlog!logimpl_v.PersistentHeader.
  alloc!vec.Vec<u8./allocator_global%.>.
 ) Bool
)
(assert
 (forall ((header! pmemlog!logimpl_v.PersistentHeader.) (out! alloc!vec.Vec<u8./allocator_global%.>.))
  (!
   (= (ens%pmemlog!logimpl_v.header_to_bytes. header! out!) (and
     (= header! (pmemlog!logimpl_v.spec_bytes_to_header.? (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
         $ (UINT 8) $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<u8./allocator_global%.>. out!)
     )))
     (= (vstd!bytes.spec_u64_from_le_bytes.? (vstd!seq.Seq.subrange.? $ (UINT 8) (vstd!view.View.view.?
         $ (TYPE%alloc!vec.Vec. $ (UINT 8) $ ALLOCATOR_GLOBAL) (Poly%alloc!vec.Vec<u8./allocator_global%.>.
          out!
         )
        ) (I pmemlog!logimpl_v.header_crc_offset.?) (I (Add pmemlog!logimpl_v.header_crc_offset.?
          8
       )))
      ) (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc (%Poly%pmemlog!logimpl_v.PersistentHeader.
        (Poly%pmemlog!logimpl_v.PersistentHeader. header!)
     )))
     (= (pmemlog!logimpl_v.spec_bytes_to_metadata.? (vstd!seq.Seq.subrange.? $ (UINT 8) (
         vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (UINT 8) $ ALLOCATOR_GLOBAL) (Poly%alloc!vec.Vec<u8./allocator_global%.>.
          out!
         )
        ) (I pmemlog!logimpl_v.header_head_offset.?) (I pmemlog!logimpl_v.header_size.?)
       )
      ) (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
        (Poly%pmemlog!logimpl_v.PersistentHeader. header!)
     )))
     (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (UINT
          8
         ) $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<u8./allocator_global%.>. out!)
       )
      ) pmemlog!logimpl_v.header_size.?
   )))
   :pattern ((ens%pmemlog!logimpl_v.header_to_bytes. header! out!))
   :qid internal_ens__pmemlog!logimpl_v.header_to_bytes._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.header_to_bytes._definition
)))

;; Function-Specs pmemlog::logimpl_v::crc_and_metadata_bytes_to_header
(declare-fun req%pmemlog!logimpl_v.crc_and_metadata_bytes_to_header. (slice%<u8.>.
  slice%<u8.>.
 ) Bool
)
(declare-const %%global_location_label%%49 Bool)
(declare-const %%global_location_label%%50 Bool)
(assert
 (forall ((crc_bytes! slice%<u8.>.) (header_bytes! slice%<u8.>.)) (!
   (= (req%pmemlog!logimpl_v.crc_and_metadata_bytes_to_header. crc_bytes! header_bytes!)
    (and
     (=>
      %%global_location_label%%49
      (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) (
          Poly%slice%<u8.>. crc_bytes!
        ))
       ) 8
     ))
     (=>
      %%global_location_label%%50
      (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) (
          Poly%slice%<u8.>. header_bytes!
        ))
       ) (Sub pmemlog!logimpl_v.header_size.? 8)
   ))))
   :pattern ((req%pmemlog!logimpl_v.crc_and_metadata_bytes_to_header. crc_bytes! header_bytes!))
   :qid internal_req__pmemlog!logimpl_v.crc_and_metadata_bytes_to_header._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.crc_and_metadata_bytes_to_header._definition
)))
(declare-fun ens%pmemlog!logimpl_v.crc_and_metadata_bytes_to_header. (slice%<u8.>.
  slice%<u8.>. pmemlog!logimpl_v.PersistentHeader.
 ) Bool
)
(assert
 (forall ((crc_bytes! slice%<u8.>.) (header_bytes! slice%<u8.>.) (out! pmemlog!logimpl_v.PersistentHeader.))
  (!
   (= (ens%pmemlog!logimpl_v.crc_and_metadata_bytes_to_header. crc_bytes! header_bytes!
     out!
    ) (and
     (has_type (Poly%pmemlog!logimpl_v.PersistentHeader. out!) TYPE%pmemlog!logimpl_v.PersistentHeader.)
     (= (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/crc (%Poly%pmemlog!logimpl_v.PersistentHeader.
        (Poly%pmemlog!logimpl_v.PersistentHeader. out!)
       )
      ) (vstd!bytes.spec_u64_from_le_bytes.? (vstd!view.View.view.? $slice (SLICE $ (UINT 8))
        (Poly%slice%<u8.>. crc_bytes!)
     )))
     (= (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
        (Poly%pmemlog!logimpl_v.PersistentHeader. out!)
       )
      ) (pmemlog!logimpl_v.spec_bytes_to_metadata.? (vstd!view.View.view.? $slice (SLICE $
         (UINT 8)
        ) (Poly%slice%<u8.>. header_bytes!)
   )))))
   :pattern ((ens%pmemlog!logimpl_v.crc_and_metadata_bytes_to_header. crc_bytes! header_bytes!
     out!
   ))
   :qid internal_ens__pmemlog!logimpl_v.crc_and_metadata_bytes_to_header._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.crc_and_metadata_bytes_to_header._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_subrange_equality_implies_index_equality
(declare-fun req%pmemlog!logimpl_v.lemma_subrange_equality_implies_index_equality.
 (Dcr Type Poly Poly Int Int) Bool
)
(declare-const %%global_location_label%%51 Bool)
(declare-const %%global_location_label%%52 Bool)
(declare-const %%global_location_label%%53 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (s1! Poly) (s2! Poly) (i! Int) (j! Int)) (!
   (= (req%pmemlog!logimpl_v.lemma_subrange_equality_implies_index_equality. T&. T& s1!
     s2! i! j!
    ) (and
     (=>
      %%global_location_label%%51
      (let
       ((tmp%%$ i!))
       (let
        ((tmp%%$1 j!))
        (and
         (and
          (<= 0 tmp%%$)
          (<= tmp%%$ tmp%%$1)
         )
         (<= tmp%%$1 (vstd!seq.Seq.len.? T&. T& s1!))
     ))))
     (=>
      %%global_location_label%%52
      (<= j! (vstd!seq.Seq.len.? T&. T& s2!))
     )
     (=>
      %%global_location_label%%53
      (= (vstd!seq.Seq.subrange.? T&. T& s1! (I i!) (I j!)) (vstd!seq.Seq.subrange.? T&.
        T& s2! (I i!) (I j!)
   )))))
   :pattern ((req%pmemlog!logimpl_v.lemma_subrange_equality_implies_index_equality. T&.
     T& s1! s2! i! j!
   ))
   :qid internal_req__pmemlog!logimpl_v.lemma_subrange_equality_implies_index_equality._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_subrange_equality_implies_index_equality._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_subrange_equality_implies_index_equality.
 (Dcr Type Poly Poly Int Int) Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (s1! Poly) (s2! Poly) (i! Int) (j! Int)) (!
   (= (ens%pmemlog!logimpl_v.lemma_subrange_equality_implies_index_equality. T&. T& s1!
     s2! i! j!
    ) (forall ((k$ Poly)) (!
      (=>
       (has_type k$ INT)
       (=>
        (let
         ((tmp%%$ (%I k$)))
         (and
          (<= i! tmp%%$)
          (< tmp%%$ j!)
        ))
        (= (vstd!seq.Seq.index.? T&. T& s1! k$) (vstd!seq.Seq.index.? T&. T& s2! k$))
      ))
      :pattern ((vstd!seq.Seq.index.? T&. T& s1! k$))
      :pattern ((vstd!seq.Seq.index.? T&. T& s2! k$))
      :qid user_pmemlog__logimpl_v__lemma_subrange_equality_implies_index_equality_37
      :skolemid skolem_user_pmemlog__logimpl_v__lemma_subrange_equality_implies_index_equality_37
   )))
   :pattern ((ens%pmemlog!logimpl_v.lemma_subrange_equality_implies_index_equality. T&.
     T& s1! s2! i! j!
   ))
   :qid internal_ens__pmemlog!logimpl_v.lemma_subrange_equality_implies_index_equality._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_subrange_equality_implies_index_equality._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_subrange_equality_implies_subsubrange_equality
(declare-fun req%pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality.
 (Dcr Type Poly Poly Int Int) Bool
)
(declare-const %%global_location_label%%54 Bool)
(declare-const %%global_location_label%%55 Bool)
(declare-const %%global_location_label%%56 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (s1! Poly) (s2! Poly) (i! Int) (j! Int)) (!
   (= (req%pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality. T&.
     T& s1! s2! i! j!
    ) (and
     (=>
      %%global_location_label%%54
      (let
       ((tmp%%$ i!))
       (let
        ((tmp%%$1 j!))
        (and
         (and
          (<= 0 tmp%%$)
          (<= tmp%%$ tmp%%$1)
         )
         (<= tmp%%$1 (vstd!seq.Seq.len.? T&. T& s1!))
     ))))
     (=>
      %%global_location_label%%55
      (<= j! (vstd!seq.Seq.len.? T&. T& s2!))
     )
     (=>
      %%global_location_label%%56
      (= (vstd!seq.Seq.subrange.? T&. T& s1! (I i!) (I j!)) (vstd!seq.Seq.subrange.? T&.
        T& s2! (I i!) (I j!)
   )))))
   :pattern ((req%pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality.
     T&. T& s1! s2! i! j!
   ))
   :qid internal_req__pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality.
 (Dcr Type Poly Poly Int Int) Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (s1! Poly) (s2! Poly) (i! Int) (j! Int)) (!
   (= (ens%pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality. T&.
     T& s1! s2! i! j!
    ) (forall ((k$ Poly) (m$ Poly)) (!
      (=>
       (and
        (has_type k$ INT)
        (has_type m$ INT)
       )
       (=>
        (let
         ((tmp%%$ (%I k$)))
         (let
          ((tmp%%$1 (%I m$)))
          (and
           (and
            (<= i! tmp%%$)
            (<= tmp%%$ tmp%%$1)
           )
           (<= tmp%%$1 j!)
        )))
        (= (vstd!seq.Seq.subrange.? T&. T& s1! k$ m$) (vstd!seq.Seq.subrange.? T&. T& s2! k$
          m$
      ))))
      :pattern ((vstd!seq.Seq.subrange.? T&. T& s1! k$ m$))
      :pattern ((vstd!seq.Seq.subrange.? T&. T& s2! k$ m$))
      :qid user_pmemlog__logimpl_v__lemma_subrange_equality_implies_subsubrange_equality_40
      :skolemid skolem_user_pmemlog__logimpl_v__lemma_subrange_equality_implies_subsubrange_equality_40
   )))
   :pattern ((ens%pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality.
     T&. T& s1! s2! i! j!
   ))
   :qid internal_ens__pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_subrange_equality_implies_subsubrange_equality_forall
(declare-fun ens%pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality_forall.
 (Dcr Type) Bool
)
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (ens%pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality_forall.
     T&. T&
    ) (forall ((s1$ Poly) (s2$ Poly) (i$ Poly) (j$ Poly) (k$ Poly) (m$ Poly)) (!
      (=>
       (and
        (has_type s1$ (TYPE%vstd!seq.Seq. T&. T&))
        (has_type s2$ (TYPE%vstd!seq.Seq. T&. T&))
        (has_type i$ INT)
        (has_type j$ INT)
        (has_type k$ INT)
        (has_type m$ INT)
       )
       (=>
        (and
         (and
          (and
           (let
            ((tmp%%$ (%I i$)))
            (let
             ((tmp%%$1 (%I j$)))
             (and
              (and
               (<= 0 tmp%%$)
               (<= tmp%%$ tmp%%$1)
              )
              (<= tmp%%$1 (vstd!seq.Seq.len.? T&. T& s1$))
           )))
           (<= (%I j$) (vstd!seq.Seq.len.? T&. T& s2$))
          )
          (= (vstd!seq.Seq.subrange.? T&. T& s1$ i$ j$) (vstd!seq.Seq.subrange.? T&. T& s2$ i$
            j$
         )))
         (let
          ((tmp%%$ (%I k$)))
          (let
           ((tmp%%$3 (%I m$)))
           (and
            (and
             (<= (%I i$) tmp%%$)
             (<= tmp%%$ tmp%%$3)
            )
            (<= tmp%%$3 (%I j$))
        ))))
        (= (vstd!seq.Seq.subrange.? T&. T& s1$ k$ m$) (vstd!seq.Seq.subrange.? T&. T& s2$ k$
          m$
      ))))
      :pattern ((vstd!seq.Seq.subrange.? T&. T& s1$ i$ j$) (vstd!seq.Seq.subrange.? T&. T&
        s2$ k$ m$
      ))
      :pattern ((vstd!seq.Seq.subrange.? T&. T& s2$ i$ j$) (vstd!seq.Seq.subrange.? T&. T&
        s1$ k$ m$
      ))
      :qid user_pmemlog__logimpl_v__lemma_subrange_equality_implies_subsubrange_equality_forall_43
      :skolemid skolem_user_pmemlog__logimpl_v__lemma_subrange_equality_implies_subsubrange_equality_forall_43
   )))
   :pattern ((ens%pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality_forall.
     T&. T&
   ))
   :qid internal_ens__pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality_forall._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_subrange_equality_implies_subsubrange_equality_forall._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_headers_unchanged
(declare-fun req%pmemlog!logimpl_v.lemma_headers_unchanged. (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.)
 Bool
)
(declare-const %%global_location_label%%57 Bool)
(declare-const %%global_location_label%%58 Bool)
(declare-const %%global_location_label%%59 Bool)
(declare-const %%global_location_label%%60 Bool)
(assert
 (forall ((old_pm! vstd!seq.Seq<u8.>.) (new_pm! vstd!seq.Seq<u8.>.)) (!
   (= (req%pmemlog!logimpl_v.lemma_headers_unchanged. old_pm! new_pm!) (and
     (=>
      %%global_location_label%%57
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_pm!)) (vstd!seq.Seq.len.?
        $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_pm!)
     )))
     (=>
      %%global_location_label%%58
      (>= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_pm!)) pmemlog!logimpl_v.contents_offset.?)
     )
     (=>
      %%global_location_label%%59
      (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
         Poly%vstd!seq.Seq<u8.>. old_pm!
        ) (I pmemlog!logimpl_v.header1_pos.?) (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_size.?))
       ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_pm!) (I pmemlog!logimpl_v.header1_pos.?)
        (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_size.?))
     )))
     (=>
      %%global_location_label%%60
      (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
         Poly%vstd!seq.Seq<u8.>. old_pm!
        ) (I pmemlog!logimpl_v.header2_pos.?) (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_size.?))
       ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_pm!) (I pmemlog!logimpl_v.header2_pos.?)
        (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_size.?))
   )))))
   :pattern ((req%pmemlog!logimpl_v.lemma_headers_unchanged. old_pm! new_pm!))
   :qid internal_req__pmemlog!logimpl_v.lemma_headers_unchanged._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_headers_unchanged._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_headers_unchanged. (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.)
 Bool
)
(assert
 (forall ((old_pm! vstd!seq.Seq<u8.>.) (new_pm! vstd!seq.Seq<u8.>.)) (!
   (= (ens%pmemlog!logimpl_v.lemma_headers_unchanged. old_pm! new_pm!) (let
     ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. old_pm!))))
     (let
      ((old_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
           (Poly%tuple%3. tmp%%$)
      )))))
      (let
       ((tmp%%$1 (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. new_pm!))))
       (let
        ((new_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
             (Poly%tuple%3. tmp%%$1)
        )))))
        (= old_headers$ new_headers$)
   )))))
   :pattern ((ens%pmemlog!logimpl_v.lemma_headers_unchanged. old_pm! new_pm!))
   :qid internal_ens__pmemlog!logimpl_v.lemma_headers_unchanged._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_headers_unchanged._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_incorruptible_bool_unchanged
(declare-fun req%pmemlog!logimpl_v.lemma_incorruptible_bool_unchanged. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>.
 ) Bool
)
(declare-const %%global_location_label%%61 Bool)
(declare-const %%global_location_label%%62 Bool)
(declare-const %%global_location_label%%63 Bool)
(assert
 (forall ((old_pm! vstd!seq.Seq<u8.>.) (new_pm! vstd!seq.Seq<u8.>.)) (!
   (= (req%pmemlog!logimpl_v.lemma_incorruptible_bool_unchanged. old_pm! new_pm!) (and
     (=>
      %%global_location_label%%61
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_pm!)) (vstd!seq.Seq.len.?
        $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_pm!)
     )))
     (=>
      %%global_location_label%%62
      (>= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_pm!)) pmemlog!logimpl_v.contents_offset.?)
     )
     (=>
      %%global_location_label%%63
      (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
         Poly%vstd!seq.Seq<u8.>. old_pm!
        ) (I pmemlog!logimpl_v.incorruptible_bool_pos.?) (I (Add pmemlog!logimpl_v.incorruptible_bool_pos.?
          8
        ))
       ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_pm!) (I pmemlog!logimpl_v.incorruptible_bool_pos.?)
        (I (Add pmemlog!logimpl_v.incorruptible_bool_pos.? 8))
   )))))
   :pattern ((req%pmemlog!logimpl_v.lemma_incorruptible_bool_unchanged. old_pm! new_pm!))
   :qid internal_req__pmemlog!logimpl_v.lemma_incorruptible_bool_unchanged._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_incorruptible_bool_unchanged._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_incorruptible_bool_unchanged. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>.
 ) Bool
)
(assert
 (forall ((old_pm! vstd!seq.Seq<u8.>.) (new_pm! vstd!seq.Seq<u8.>.)) (!
   (= (ens%pmemlog!logimpl_v.lemma_incorruptible_bool_unchanged. old_pm! new_pm!) (let
     ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. old_pm!))))
     (let
      ((old_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
      (let
       ((tmp%%$1 (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. new_pm!))))
       (let
        ((new_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$1))))))
        (= old_ib$ new_ib$)
   )))))
   :pattern ((ens%pmemlog!logimpl_v.lemma_incorruptible_bool_unchanged. old_pm! new_pm!))
   :qid internal_ens__pmemlog!logimpl_v.lemma_incorruptible_bool_unchanged._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_incorruptible_bool_unchanged._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_append_data_update_view
(declare-fun req%pmemlog!logimpl_v.lemma_append_data_update_view. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. Int
 ) Bool
)
(declare-const %%global_location_label%%64 Bool)
(declare-const %%global_location_label%%65 Bool)
(declare-const %%global_location_label%%66 Bool)
(declare-const %%global_location_label%%67 Bool)
(assert
 (forall ((pm! vstd!seq.Seq<u8.>.) (new_bytes! vstd!seq.Seq<u8.>.) (write_addr! Int))
  (!
   (= (req%pmemlog!logimpl_v.lemma_append_data_update_view. pm! new_bytes! write_addr!)
    (and
     (=>
      %%global_location_label%%64
      (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
         pm!
     ))))
     (=>
      %%global_location_label%%65
      (> (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. pm!)) pmemlog!logimpl_v.contents_offset.?)
     )
     (=>
      %%global_location_label%%66
      (let
       ((tmp%%$ write_addr!))
       (and
        (<= pmemlog!logimpl_v.contents_offset.? tmp%%$)
        (< tmp%%$ (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. pm!)))
     )))
     (=>
      %%global_location_label%%67
      (let
       ((live_header$ (pmemlog!logimpl_v.spec_get_live_header.? (Poly%vstd!seq.Seq<u8.>. pm!))))
       (let
        ((physical_head$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head
             (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
               (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                 (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
            )))))
           ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
             (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
               (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                 (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
        )))))))))
        (let
         ((physical_tail$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail
              (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                  (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
             )))))
            ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
              (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                  (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
         )))))))))
         (and
          (=>
           (<= physical_head$ physical_tail$)
           (and
            (and
             (<= (Add write_addr! (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_bytes!)))
              (Add (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                  (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                    (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
                ))))
               ) pmemlog!logimpl_v.contents_offset.?
             ))
             (=>
              (< write_addr! physical_head$)
              (<= (Add write_addr! (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_bytes!)))
               physical_head$
            )))
            (or
             (<= physical_tail$ write_addr!)
             (< write_addr! physical_head$)
          )))
          (=>
           (< physical_tail$ physical_head$)
           (let
            ((tmp%%$ write_addr!))
            (let
             ((tmp%%$1 (Add write_addr! (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_bytes!)))))
             (and
              (and
               (<= physical_tail$ tmp%%$)
               (<= tmp%%$ tmp%%$1)
              )
              (< tmp%%$1 physical_head$)
   )))))))))))
   :pattern ((req%pmemlog!logimpl_v.lemma_append_data_update_view. pm! new_bytes! write_addr!))
   :qid internal_req__pmemlog!logimpl_v.lemma_append_data_update_view._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_append_data_update_view._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_append_data_update_view. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. Int
 ) Bool
)
(assert
 (forall ((pm! vstd!seq.Seq<u8.>.) (new_bytes! vstd!seq.Seq<u8.>.) (write_addr! Int))
  (!
   (= (ens%pmemlog!logimpl_v.lemma_append_data_update_view. pm! new_bytes! write_addr!)
    (and
     (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
        pm!
     )))
     (pmemlog!logimpl_v.update_data_view_postcond.? (Poly%vstd!seq.Seq<u8.>. pm!) (Poly%vstd!seq.Seq<u8.>.
       new_bytes!
      ) (I write_addr!)
   )))
   :pattern ((ens%pmemlog!logimpl_v.lemma_append_data_update_view. pm! new_bytes! write_addr!))
   :qid internal_ens__pmemlog!logimpl_v.lemma_append_data_update_view._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_append_data_update_view._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_same_log_state
(declare-fun req%pmemlog!logimpl_v.lemma_same_log_state. (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.)
 Bool
)
(declare-const %%global_location_label%%68 Bool)
(declare-const %%global_location_label%%69 Bool)
(declare-const %%global_location_label%%70 Bool)
(declare-const %%global_location_label%%71 Bool)
(assert
 (forall ((old_pm! vstd!seq.Seq<u8.>.) (new_pm! vstd!seq.Seq<u8.>.)) (!
   (= (req%pmemlog!logimpl_v.lemma_same_log_state. old_pm! new_pm!) (and
     (=>
      %%global_location_label%%68
      (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
         old_pm!
     ))))
     (=>
      %%global_location_label%%69
      (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
         new_pm!
     ))))
     (=>
      %%global_location_label%%70
      (pmemlog!logimpl_v.live_data_view_eq.? (Poly%vstd!seq.Seq<u8.>. old_pm!) (Poly%vstd!seq.Seq<u8.>.
        new_pm!
     )))
     (=>
      %%global_location_label%%71
      (let
       ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. old_pm!))))
       (let
        ((old_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
        (let
         ((old_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
              (Poly%tuple%3. tmp%%$)
         )))))
         (let
          ((old_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                tmp%%$
          ))))))
          (let
           ((tmp%%$1 (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. new_pm!))))
           (let
            ((new_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$1))))))
            (let
             ((new_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
                  (Poly%tuple%3. tmp%%$1)
             )))))
             (let
              ((new_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                    tmp%%$1
              ))))))
              (and
               (and
                (and
                 (or
                  (= old_ib$ pmemlog!pmemspec_t.cdb0_val.?)
                  (= old_ib$ pmemlog!pmemspec_t.cdb1_val.?)
                 )
                 (= old_ib$ new_ib$)
                )
                (=>
                 (= old_ib$ pmemlog!pmemspec_t.cdb0_val.?)
                 (= (pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
                    (Poly%pmemlog!logimpl_v.HeaderView. old_headers$)
                   )
                  ) (pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
                    (Poly%pmemlog!logimpl_v.HeaderView. new_headers$)
               )))))
               (=>
                (= old_ib$ pmemlog!pmemspec_t.cdb1_val.?)
                (= (pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
                   (Poly%pmemlog!logimpl_v.HeaderView. old_headers$)
                  )
                 ) (pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
                   (Poly%pmemlog!logimpl_v.HeaderView. new_headers$)
   ))))))))))))))))
   :pattern ((req%pmemlog!logimpl_v.lemma_same_log_state. old_pm! new_pm!))
   :qid internal_req__pmemlog!logimpl_v.lemma_same_log_state._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_same_log_state._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_same_log_state. (vstd!seq.Seq<u8.>. vstd!seq.Seq<u8.>.)
 Bool
)
(assert
 (forall ((old_pm! vstd!seq.Seq<u8.>.) (new_pm! vstd!seq.Seq<u8.>.)) (!
   (= (ens%pmemlog!logimpl_v.lemma_same_log_state. old_pm! new_pm!) (ext_eq false (TYPE%core!option.Option.
      $ TYPE%pmemlog!infinitelog_t.AbstractInfiniteLogState.
     ) (Poly%core!option.Option. (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
        old_pm!
      ))
     ) (Poly%core!option.Option. (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
        new_pm!
   )))))
   :pattern ((ens%pmemlog!logimpl_v.lemma_same_log_state. old_pm! new_pm!))
   :qid internal_ens__pmemlog!logimpl_v.lemma_same_log_state._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_same_log_state._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_append_data_update_view_crash
(declare-fun req%pmemlog!logimpl_v.lemma_append_data_update_view_crash. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. Int vstd!set.Set<int.>.
 ) Bool
)
(declare-const %%global_location_label%%72 Bool)
(declare-const %%global_location_label%%73 Bool)
(declare-const %%global_location_label%%74 Bool)
(declare-const %%global_location_label%%75 Bool)
(assert
 (forall ((pm! vstd!seq.Seq<u8.>.) (new_bytes! vstd!seq.Seq<u8.>.) (write_addr! Int)
   (chunks_flushed! vstd!set.Set<int.>.)
  ) (!
   (= (req%pmemlog!logimpl_v.lemma_append_data_update_view_crash. pm! new_bytes! write_addr!
     chunks_flushed!
    ) (and
     (=>
      %%global_location_label%%72
      (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
         pm!
     ))))
     (=>
      %%global_location_label%%73
      (> (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. pm!)) pmemlog!logimpl_v.contents_offset.?)
     )
     (=>
      %%global_location_label%%74
      (let
       ((tmp%%$ write_addr!))
       (and
        (<= pmemlog!logimpl_v.contents_offset.? tmp%%$)
        (< tmp%%$ (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. pm!)))
     )))
     (=>
      %%global_location_label%%75
      (let
       ((live_header$ (pmemlog!logimpl_v.spec_get_live_header.? (Poly%vstd!seq.Seq<u8.>. pm!))))
       (let
        ((physical_head$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head
             (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
               (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                 (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
            )))))
           ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
             (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
               (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                 (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
        )))))))))
        (let
         ((physical_tail$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail
              (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                  (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
             )))))
            ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
              (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                  (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
         )))))))))
         (and
          (=>
           (<= physical_head$ physical_tail$)
           (<= (Add write_addr! (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_bytes!)))
            (Add (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
              (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                  (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
              ))))
             ) pmemlog!logimpl_v.contents_offset.?
          )))
          (=>
           (< physical_tail$ physical_head$)
           (< (Add write_addr! (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_bytes!)))
            physical_head$
   )))))))))
   :pattern ((req%pmemlog!logimpl_v.lemma_append_data_update_view_crash. pm! new_bytes!
     write_addr! chunks_flushed!
   ))
   :qid internal_req__pmemlog!logimpl_v.lemma_append_data_update_view_crash._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_append_data_update_view_crash._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_append_data_update_view_crash. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. Int vstd!set.Set<int.>.
 ) Bool
)
(assert
 (forall ((pm! vstd!seq.Seq<u8.>.) (new_bytes! vstd!seq.Seq<u8.>.) (write_addr! Int)
   (chunks_flushed! vstd!set.Set<int.>.)
  ) (!
   (= (ens%pmemlog!logimpl_v.lemma_append_data_update_view_crash. pm! new_bytes! write_addr!
     chunks_flushed!
    ) (and
     (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
        pm!
     )))
     (let
      ((new_pm$ (pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.? (
          Poly%vstd!seq.Seq<u8.>. pm!
         ) (I write_addr!) (Poly%vstd!seq.Seq<u8.>. new_bytes!) (Poly%vstd!set.Set<int.>. chunks_flushed!)
      )))
      (let
       ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. pm!))))
       (let
        ((old_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
        (let
         ((old_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
              (Poly%tuple%3. tmp%%$)
         )))))
         (let
          ((old_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                tmp%%$
          ))))))
          (let
           ((tmp%%$1 (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. new_pm$))))
           (let
            ((new_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$1))))))
            (let
             ((new_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
                  (Poly%tuple%3. tmp%%$1)
             )))))
             (let
              ((new_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                    tmp%%$1
              ))))))
              (and
               (and
                (and
                 (and
                  (and
                   (= old_ib$ new_ib$)
                   (= old_headers$ new_headers$)
                  )
                  (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_data$)) (vstd!seq.Seq.len.?
                    $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_data$)
                 )))
                 (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                    Poly%vstd!seq.Seq<u8.>. new_data$
                   ) (I 0) (I (Sub write_addr! pmemlog!logimpl_v.contents_offset.?))
                  ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_data$) (I 0) (I
                    (Sub write_addr! pmemlog!logimpl_v.contents_offset.?)
                ))))
                (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT 8) (
                   Poly%vstd!seq.Seq<u8.>. new_data$
                  ) (I (Add (Sub write_addr! pmemlog!logimpl_v.contents_offset.?) (vstd!seq.Seq.len.?
                     $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_bytes!)
                   ))
                  ) (I (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_data$)))
                 ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_data$) (I (Add (Sub
                     write_addr! pmemlog!logimpl_v.contents_offset.?
                    ) (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_bytes!))
                   )
                  ) (I (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. old_data$)))
               )))
               (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
                  new_pm$
   )))))))))))))))
   :pattern ((ens%pmemlog!logimpl_v.lemma_append_data_update_view_crash. pm! new_bytes!
     write_addr! chunks_flushed!
   ))
   :qid internal_ens__pmemlog!logimpl_v.lemma_append_data_update_view_crash._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_append_data_update_view_crash._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_data_write_is_safe
(declare-fun req%pmemlog!logimpl_v.lemma_data_write_is_safe. (Dcr Type vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. Int Poly
 ) Bool
)
(declare-const %%global_location_label%%76 Bool)
(declare-const %%global_location_label%%77 Bool)
(declare-const %%global_location_label%%78 Bool)
(declare-const %%global_location_label%%79 Bool)
(declare-const %%global_location_label%%80 Bool)
(declare-const %%global_location_label%%81 Bool)
(assert
 (forall ((Perm&. Dcr) (Perm& Type) (pm! vstd!seq.Seq<u8.>.) (bytes! vstd!seq.Seq<u8.>.)
   (write_addr! Int) (perm! Poly)
  ) (!
   (= (req%pmemlog!logimpl_v.lemma_data_write_is_safe. Perm&. Perm& pm! bytes! write_addr!
     perm!
    ) (and
     (=>
      %%global_location_label%%76
      (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
         pm!
     ))))
     (=>
      %%global_location_label%%77
      (> (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. pm!)) pmemlog!logimpl_v.contents_offset.?)
     )
     (=>
      %%global_location_label%%78
      (let
       ((tmp%%$ write_addr!))
       (and
        (<= pmemlog!logimpl_v.contents_offset.? tmp%%$)
        (< tmp%%$ (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. pm!)))
     )))
     (=>
      %%global_location_label%%79
      (%B (pmemlog!sccf.CheckPermission.check_permission.? Perm&. Perm& $ (TYPE%vstd!seq.Seq.
         $ (UINT 8)
        ) perm! (Poly%vstd!seq.Seq<u8.>. pm!)
     )))
     (=>
      %%global_location_label%%80
      (pmemlog!logimpl_v.permissions_depend_only_on_recovery_view.? Perm&. Perm& perm!)
     )
     (=>
      %%global_location_label%%81
      (let
       ((live_header$ (pmemlog!logimpl_v.spec_get_live_header.? (Poly%vstd!seq.Seq<u8.>. pm!))))
       (let
        ((physical_head$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/head
             (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
               (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                 (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
            )))))
           ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
             (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
               (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                 (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
        )))))))))
        (let
         ((physical_tail$ (pmemlog!logimpl_v.spec_addr_logical_to_physical.? (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/tail
              (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                  (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
             )))))
            ) (I (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
              (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                  (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
         )))))))))
         (and
          (=>
           (<= physical_head$ physical_tail$)
           (and
            (and
             (<= (Add write_addr! (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes!)))
              (Add (pmemlog!logimpl_v.PersistentHeaderMetadata./PersistentHeaderMetadata/log_size
                (%Poly%pmemlog!logimpl_v.PersistentHeaderMetadata. (Poly%pmemlog!logimpl_v.PersistentHeaderMetadata.
                  (pmemlog!logimpl_v.PersistentHeader./PersistentHeader/metadata (%Poly%pmemlog!logimpl_v.PersistentHeader.
                    (Poly%pmemlog!logimpl_v.PersistentHeader. live_header$)
                ))))
               ) pmemlog!logimpl_v.contents_offset.?
             ))
             (=>
              (< write_addr! physical_head$)
              (<= (Add write_addr! (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes!)))
               physical_head$
            )))
            (or
             (<= physical_tail$ write_addr!)
             (< write_addr! physical_head$)
          )))
          (=>
           (< physical_tail$ physical_head$)
           (let
            ((tmp%%$ write_addr!))
            (let
             ((tmp%%$1 (Add write_addr! (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes!)))))
             (and
              (and
               (<= physical_tail$ tmp%%$)
               (<= tmp%%$ tmp%%$1)
              )
              (< tmp%%$1 physical_head$)
   )))))))))))
   :pattern ((req%pmemlog!logimpl_v.lemma_data_write_is_safe. Perm&. Perm& pm! bytes!
     write_addr! perm!
   ))
   :qid internal_req__pmemlog!logimpl_v.lemma_data_write_is_safe._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_data_write_is_safe._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_data_write_is_safe. (Dcr Type vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. Int Poly
 ) Bool
)
(assert
 (forall ((Perm&. Dcr) (Perm& Type) (pm! vstd!seq.Seq<u8.>.) (bytes! vstd!seq.Seq<u8.>.)
   (write_addr! Int) (perm! Poly)
  ) (!
   (= (ens%pmemlog!logimpl_v.lemma_data_write_is_safe. Perm&. Perm& pm! bytes! write_addr!
     perm!
    ) (and
     (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
        pm!
     )))
     (forall ((chunks_flushed$ Poly)) (!
       (=>
        (has_type chunks_flushed$ (TYPE%vstd!set.Set. $ INT))
        (%B (let
          ((new_pm$ (pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.? (
              Poly%vstd!seq.Seq<u8.>. pm!
             ) (I write_addr!) (Poly%vstd!seq.Seq<u8.>. bytes!) chunks_flushed$
          )))
          (pmemlog!sccf.CheckPermission.check_permission.? Perm&. Perm& $ (TYPE%vstd!seq.Seq.
            $ (UINT 8)
           ) perm! (Poly%vstd!seq.Seq<u8.>. new_pm$)
       ))))
       :pattern ((pmemlog!pmemspec_t.update_contents_to_reflect_partially_flushed_write.?
         (Poly%vstd!seq.Seq<u8.>. pm!) (I write_addr!) (Poly%vstd!seq.Seq<u8.>. bytes!) chunks_flushed$
       ))
       :qid user_pmemlog__logimpl_v__lemma_data_write_is_safe_46
       :skolemid skolem_user_pmemlog__logimpl_v__lemma_data_write_is_safe_46
     ))
     (%B (let
       ((new_pm$ (pmemlog!pmemspec_t.update_contents_to_reflect_write.? (Poly%vstd!seq.Seq<u8.>.
           pm!
          ) (I write_addr!) (Poly%vstd!seq.Seq<u8.>. bytes!)
       )))
       (pmemlog!sccf.CheckPermission.check_permission.? Perm&. Perm& $ (TYPE%vstd!seq.Seq.
         $ (UINT 8)
        ) perm! (Poly%vstd!seq.Seq<u8.>. new_pm$)
     )))
     (pmemlog!logimpl_v.update_data_view_postcond.? (Poly%vstd!seq.Seq<u8.>. pm!) (Poly%vstd!seq.Seq<u8.>.
       bytes!
      ) (I write_addr!)
   )))
   :pattern ((ens%pmemlog!logimpl_v.lemma_data_write_is_safe. Perm&. Perm& pm! bytes!
     write_addr! perm!
   ))
   :qid internal_ens__pmemlog!logimpl_v.lemma_data_write_is_safe._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_data_write_is_safe._definition
)))

;; Function-Specs pmemlog::logimpl_v::lemma_inactive_header_update_view
(declare-fun req%pmemlog!logimpl_v.lemma_inactive_header_update_view. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. Int
 ) Bool
)
(declare-const %%global_location_label%%82 Bool)
(declare-const %%global_location_label%%83 Bool)
(declare-const %%global_location_label%%84 Bool)
(declare-const %%global_location_label%%85 Bool)
(declare-const %%global_location_label%%86 Bool)
(assert
 (forall ((pm! vstd!seq.Seq<u8.>.) (new_header_bytes! vstd!seq.Seq<u8.>.) (header_pos!
    Int
   )
  ) (!
   (= (req%pmemlog!logimpl_v.lemma_inactive_header_update_view. pm! new_header_bytes!
     header_pos!
    ) (and
     (=>
      %%global_location_label%%82
      (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
         pm!
     ))))
     (=>
      %%global_location_label%%83
      (or
       (= header_pos! pmemlog!logimpl_v.header1_pos.?)
       (= header_pos! pmemlog!logimpl_v.header2_pos.?)
     ))
     (=>
      %%global_location_label%%84
      (let
       ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. pm!))))
       (let
        ((old_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
        (let
         ((old_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
              (Poly%tuple%3. tmp%%$)
         )))))
         (let
          ((old_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                tmp%%$
          ))))))
          (and
           (=>
            (= old_ib$ pmemlog!pmemspec_t.cdb0_val.?)
            (= header_pos! pmemlog!logimpl_v.header2_pos.?)
           )
           (=>
            (= old_ib$ pmemlog!pmemspec_t.cdb1_val.?)
            (= header_pos! pmemlog!logimpl_v.header1_pos.?)
     )))))))
     (=>
      %%global_location_label%%85
      (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_header_bytes!)) pmemlog!logimpl_v.header_size.?)
     )
     (=>
      %%global_location_label%%86
      (> (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. pm!)) pmemlog!logimpl_v.contents_offset.?)
   )))
   :pattern ((req%pmemlog!logimpl_v.lemma_inactive_header_update_view. pm! new_header_bytes!
     header_pos!
   ))
   :qid internal_req__pmemlog!logimpl_v.lemma_inactive_header_update_view._definition
   :skolemid skolem_internal_req__pmemlog!logimpl_v.lemma_inactive_header_update_view._definition
)))
(declare-fun ens%pmemlog!logimpl_v.lemma_inactive_header_update_view. (vstd!seq.Seq<u8.>.
  vstd!seq.Seq<u8.>. Int
 ) Bool
)
(assert
 (forall ((pm! vstd!seq.Seq<u8.>.) (new_header_bytes! vstd!seq.Seq<u8.>.) (header_pos!
    Int
   )
  ) (!
   (= (ens%pmemlog!logimpl_v.lemma_inactive_header_update_view. pm! new_header_bytes!
     header_pos!
    ) (let
     ((new_pm$ (pmemlog!pmemspec_t.update_contents_to_reflect_write.? (Poly%vstd!seq.Seq<u8.>.
         pm!
        ) (I header_pos!) (Poly%vstd!seq.Seq<u8.>. new_header_bytes!)
     )))
     (let
      ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. pm!))))
      (let
       ((old_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((old_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
             (Poly%tuple%3. tmp%%$)
        )))))
        (let
         ((old_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
               tmp%%$
         ))))))
         (let
          ((tmp%%$1 (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. new_pm$))))
          (let
           ((new_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$1))))))
           (let
            ((new_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
                 (Poly%tuple%3. tmp%%$1)
            )))))
            (let
             ((new_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                   tmp%%$1
             ))))))
             (and
              (and
               (and
                (and
                 (= old_ib$ new_ib$)
                 (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (Poly%vstd!seq.Seq<u8.>. old_data$)
                  (Poly%vstd!seq.Seq<u8.>. old_data$)
                ))
                (=>
                 (= header_pos! pmemlog!logimpl_v.header1_pos.?)
                 (= (pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
                    (Poly%pmemlog!logimpl_v.HeaderView. old_headers$)
                   )
                  ) (pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
                    (Poly%pmemlog!logimpl_v.HeaderView. new_headers$)
               )))))
               (=>
                (= header_pos! pmemlog!logimpl_v.header2_pos.?)
                (= (pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
                   (Poly%pmemlog!logimpl_v.HeaderView. old_headers$)
                  )
                 ) (pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
                   (Poly%pmemlog!logimpl_v.HeaderView. new_headers$)
              )))))
              (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
                 new_pm$
   ))))))))))))))
   :pattern ((ens%pmemlog!logimpl_v.lemma_inactive_header_update_view. pm! new_header_bytes!
     header_pos!
   ))
   :qid internal_ens__pmemlog!logimpl_v.lemma_inactive_header_update_view._definition
   :skolemid skolem_internal_ens__pmemlog!logimpl_v.lemma_inactive_header_update_view._definition
)))

;; Function-Def pmemlog::logimpl_v::lemma_inactive_header_update_view
;; src/logimpl_v.rs:538:5: 538:108 (#0)
(get-info :all-statistics)
(push)
 (declare-const pm! vstd!seq.Seq<u8.>.)
 (declare-const new_header_bytes! vstd!seq.Seq<u8.>.)
 (declare-const header_pos! Int)
 (declare-const tmp%1 Bool)
 (declare-const tmp%2 Bool)
 (declare-const tmp%3 Bool)
 (declare-const tmp%4 Bool)
 (declare-const tmp%5 Bool)
 (declare-const new_pm@ vstd!seq.Seq<u8.>.)
 (declare-const tmp%%@ tuple%3.)
 (declare-const new_ib@ Int)
 (declare-const new_headers@ pmemlog!logimpl_v.HeaderView.)
 (declare-const new_data@ vstd!seq.Seq<u8.>.)
 (assert
  fuel_defaults
 )
 (assert
  (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
     pm!
 ))))
 (assert
  (or
   (= header_pos! pmemlog!logimpl_v.header1_pos.?)
   (= header_pos! pmemlog!logimpl_v.header2_pos.?)
 ))
 (assert
  (let
   ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. pm!))))
   (let
    ((old_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
    (let
     ((old_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
          (Poly%tuple%3. tmp%%$)
     )))))
     (let
      ((old_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
            tmp%%$
      ))))))
      (and
       (=>
        (= old_ib$ pmemlog!pmemspec_t.cdb0_val.?)
        (= header_pos! pmemlog!logimpl_v.header2_pos.?)
       )
       (=>
        (= old_ib$ pmemlog!pmemspec_t.cdb1_val.?)
        (= header_pos! pmemlog!logimpl_v.header1_pos.?)
 )))))))
 (assert
  (= (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_header_bytes!)) pmemlog!logimpl_v.header_size.?)
 )
 (assert
  (> (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. pm!)) pmemlog!logimpl_v.contents_offset.?)
 )
 (declare-const %%switch_label%%0 Bool)
 ;; assertion failed
 (declare-const %%location_label%%0 Bool)
 ;; assertion failed
 (declare-const %%location_label%%1 Bool)
 ;; assertion failed
 (declare-const %%location_label%%2 Bool)
 ;; assertion failed
 (declare-const %%location_label%%3 Bool)
 ;; assertion failed
 (declare-const %%location_label%%4 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%5 Bool)
 (assert
  (not (=>
    (= new_pm@ (pmemlog!pmemspec_t.update_contents_to_reflect_write.? (Poly%vstd!seq.Seq<u8.>.
       pm!
      ) (I header_pos!) (Poly%vstd!seq.Seq<u8.>. new_header_bytes!)
    ))
    (=>
     (= tmp%%@ (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. new_pm@)))
     (=>
      (= new_ib@ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%@)))))
      (=>
       (= new_headers@ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
           (Poly%tuple%3. tmp%%@)
       ))))
       (=>
        (= new_data@ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
             tmp%%@
        )))))
        (=>
         (= tmp%1 (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT
             8
            ) (Poly%vstd!seq.Seq<u8.>. pm!) (I pmemlog!logimpl_v.incorruptible_bool_pos.?) (I
             (Add pmemlog!logimpl_v.incorruptible_bool_pos.? 8)
            )
           ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_pm@) (I pmemlog!logimpl_v.incorruptible_bool_pos.?)
            (I (Add pmemlog!logimpl_v.incorruptible_bool_pos.? 8))
         )))
         (and
          (=>
           %%location_label%%0
           tmp%1
          )
          (=>
           tmp%1
           (or
            (and
             (=>
              (= header_pos! pmemlog!logimpl_v.header1_pos.?)
              (=>
               (= tmp%2 (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT
                   8
                  ) (Poly%vstd!seq.Seq<u8.>. pm!) (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_crc_offset.?))
                  (I (Add (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_crc_offset.?)
                    8
                  ))
                 ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_pm@) (I (Add pmemlog!logimpl_v.header2_pos.?
                    pmemlog!logimpl_v.header_crc_offset.?
                   )
                  ) (I (Add (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_crc_offset.?)
                    8
               )))))
               (and
                (=>
                 %%location_label%%1
                 tmp%2
                )
                (=>
                 tmp%2
                 (=>
                  (= tmp%3 (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT
                      8
                     ) (Poly%vstd!seq.Seq<u8.>. pm!) (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_head_offset.?))
                     (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_size.?))
                    ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_pm@) (I (Add pmemlog!logimpl_v.header2_pos.?
                       pmemlog!logimpl_v.header_head_offset.?
                      )
                     ) (I (Add pmemlog!logimpl_v.header2_pos.? pmemlog!logimpl_v.header_size.?))
                  )))
                  (and
                   (=>
                    %%location_label%%2
                    tmp%3
                   )
                   (=>
                    tmp%3
                    %%switch_label%%0
             )))))))
             (=>
              (not (= header_pos! pmemlog!logimpl_v.header1_pos.?))
              (=>
               (= tmp%4 (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT
                   8
                  ) (Poly%vstd!seq.Seq<u8.>. pm!) (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_crc_offset.?))
                  (I (Add (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_crc_offset.?)
                    8
                  ))
                 ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_pm@) (I (Add pmemlog!logimpl_v.header1_pos.?
                    pmemlog!logimpl_v.header_crc_offset.?
                   )
                  ) (I (Add (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_crc_offset.?)
                    8
               )))))
               (and
                (=>
                 %%location_label%%3
                 tmp%4
                )
                (=>
                 tmp%4
                 (=>
                  (= tmp%5 (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (vstd!seq.Seq.subrange.? $ (UINT
                      8
                     ) (Poly%vstd!seq.Seq<u8.>. pm!) (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_head_offset.?))
                     (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_size.?))
                    ) (vstd!seq.Seq.subrange.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. new_pm@) (I (Add pmemlog!logimpl_v.header1_pos.?
                       pmemlog!logimpl_v.header_head_offset.?
                      )
                     ) (I (Add pmemlog!logimpl_v.header1_pos.? pmemlog!logimpl_v.header_size.?))
                  )))
                  (and
                   (=>
                    %%location_label%%4
                    tmp%5
                   )
                   (=>
                    tmp%5
                    %%switch_label%%0
            ))))))))
            (and
             (not %%switch_label%%0)
             (=>
              %%location_label%%5
              (let
               ((new_pm$ (pmemlog!pmemspec_t.update_contents_to_reflect_write.? (Poly%vstd!seq.Seq<u8.>.
                   pm!
                  ) (I header_pos!) (Poly%vstd!seq.Seq<u8.>. new_header_bytes!)
               )))
               (let
                ((tmp%%$ (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. pm!))))
                (let
                 ((old_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
                 (let
                  ((old_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
                       (Poly%tuple%3. tmp%%$)
                  )))))
                  (let
                   ((old_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                         tmp%%$
                   ))))))
                   (let
                    ((tmp%%$1 (pmemlog!logimpl_v.pm_to_views.? (Poly%vstd!seq.Seq<u8.>. new_pm$))))
                    (let
                     ((new_ib$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$1))))))
                     (let
                      ((new_headers$ (%Poly%pmemlog!logimpl_v.HeaderView. (tuple%3./tuple%3/1 (%Poly%tuple%3.
                           (Poly%tuple%3. tmp%%$1)
                      )))))
                      (let
                       ((new_data$ (%Poly%vstd!seq.Seq<u8.>. (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3.
                             tmp%%$1
                       ))))))
                       (and
                        (and
                         (and
                          (and
                           (= old_ib$ new_ib$)
                           (ext_eq false (TYPE%vstd!seq.Seq. $ (UINT 8)) (Poly%vstd!seq.Seq<u8.>. old_data$)
                            (Poly%vstd!seq.Seq<u8.>. old_data$)
                          ))
                          (=>
                           (= header_pos! pmemlog!logimpl_v.header1_pos.?)
                           (ext_eq false TYPE%pmemlog!logimpl_v.PersistentHeader. (Poly%pmemlog!logimpl_v.PersistentHeader.
                             (pmemlog!logimpl_v.HeaderView./HeaderView/header2 (%Poly%pmemlog!logimpl_v.HeaderView.
                               (Poly%pmemlog!logimpl_v.HeaderView. old_headers$)
                             ))
                            ) (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.HeaderView./HeaderView/header2
                              (%Poly%pmemlog!logimpl_v.HeaderView. (Poly%pmemlog!logimpl_v.HeaderView. new_headers$))
                         )))))
                         (=>
                          (= header_pos! pmemlog!logimpl_v.header2_pos.?)
                          (ext_eq false TYPE%pmemlog!logimpl_v.PersistentHeader. (Poly%pmemlog!logimpl_v.PersistentHeader.
                            (pmemlog!logimpl_v.HeaderView./HeaderView/header1 (%Poly%pmemlog!logimpl_v.HeaderView.
                              (Poly%pmemlog!logimpl_v.HeaderView. old_headers$)
                            ))
                           ) (Poly%pmemlog!logimpl_v.PersistentHeader. (pmemlog!logimpl_v.HeaderView./HeaderView/header1
                             (%Poly%pmemlog!logimpl_v.HeaderView. (Poly%pmemlog!logimpl_v.HeaderView. new_headers$))
                        )))))
                        (is-core!option.Option./Some (pmemlog!logimpl_v.impl&%0.recover.? (Poly%vstd!seq.Seq<u8.>.
                           new_pm$
 ))))))))))))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
